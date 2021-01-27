import 'package:Qactus/json_processing/Article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../HttpFeeds.dart';
import 'ArticleScreen.dart';
import 'ErrorScreen.dart';
import 'LoadingScreen.dart';

enum Options { options, about }

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  String _version;
  String _buildNumber;
  bool _isLoading = false;

  ScrollController _scrollController;

  Future<List<Article>> _articles;

  @override
  void initState() {
    super.initState();
    _loadArticles();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    // TODO: put the following in the proper section
    // PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    //   _version = packageInfo.version;
    //   _buildNumber = packageInfo.buildNumber;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: _articles,
      builder: (builder, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        } else if (!snapshot.hasData) {
          return LoadingScreen();
        }

        return Scaffold(
          // TODO: investigate the drawer as a suitable alternative for options
          // drawer: new Drawer(
          //   child: new ListView(
          //     children: <Widget>[
          //       new ListTile(
          //         title: new Text("WELCOME"),
          //       ),
          //       new Divider(),
          //       new ListTile(
          //           title: new Text("Settings"),
          //           trailing: new Icon(Icons.settings),
          //           onTap: () {}),
          //     ],
          //   ),
          // ),
          appBar: AppBar(
            leading: PopupMenuButton<Options>(
              icon: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              ),
              // TODO: implement these Option and About pages (or Drawer)
              onSelected: (Options result) {
                switch (result) {
                  case Options.options:
                    break;
                  case Options.about:
                    AboutDialog(
                      applicationName: 'QActus',
                      applicationVersion:
                          _version + "(Build " + _buildNumber + ")",
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
                const PopupMenuItem<Options>(
                  value: Options.options,
                  child: Text('Options'),
                ),
                const PopupMenuItem<Options>(
                  value: Options.about,
                  child: Text('A propos'),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                // TODO: add search functionality here: https://pub.dev/packages/material_floating_search_bar
                onPressed: () => AlertDialog(
                  title: Text('Recherche'),
                  content: Text('Bientôt ici les recherches'),
                ),
              )
            ],
            title: Text(
              'QActus',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Color.fromRGBO(232, 8, 50, 1),
            ),
          ),
          body: RefreshIndicator(
            key: _refreshKey,
            onRefresh: _refreshList,
            child: Scrollbar(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data.length,
                itemBuilder: (builder, index) {
                  Article item = snapshot.data[index];
                  String categories =
                      item.embedded.wpTerm[0].map((e) => e.name).join(', ');

                  return Container(
                    margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          _createRoute(item),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              categories.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                color: Color.fromRGBO(119, 119, 119, 1),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 15.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                Center(
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: item.imageUrl,
                                    fadeOutDuration:
                                        new Duration(milliseconds: 300),
                                    fadeOutCurve: Curves.decelerate,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              item.title.text,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0,
                                color: Color.fromRGBO(232, 8, 50, 1),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              item.excerpt.text,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.3,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future _refreshList() async {
    _refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      HttpFeeds().getArticles();
    });
  }

  // This deserved its own method because *transitions*
  Route _createRoute(Article item) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ArticleScreen(
        article: item,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // If we reach the end of page, load the next one
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      HttpFeeds().incrementPageNumber();
      setState(() {
        _isLoading = true;
        _loadArticles();
        _isLoading = false;
      });
    }
  }

  void _loadArticles() async {
    _articles = HttpFeeds().getArticles();
  }
}
