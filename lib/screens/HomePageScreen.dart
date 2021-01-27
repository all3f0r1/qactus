import 'package:Qactus/json_processing/Article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

import '../HttpFeeds.dart';
import 'ArticleScreen.dart';
import 'ErrorScreen.dart';
import 'LoadingScreen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
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
          drawer: Drawer(
            child: Container(
              width: 100,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/header.png",
                          width: 100,
                        ),
                        Text(
                          'L\'INFORMATEUR.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Color.fromRGBO(237, 28, 36, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text("Options"),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text("A propos"),
                    leading: Icon(Icons.alternate_email),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
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
            title: Row(
              children: [
                Text(
                  'Qact',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'us',
                  style: TextStyle(
                    color: Color.fromRGBO(237, 28, 36, 1),
                  ),
                ),
              ],
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
                  String categories = item.embedded.wpTerm[0]
                      .map((e) => e.name)
                      .join(', ')
                      .toUpperCase();
                  String date = dateFormatter.format(item.date);

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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  categories,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(119, 119, 119, 1),
                                  ),
                                ),
                                Text(
                                  date,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(119, 119, 119, 1),
                                  ),
                                ),
                              ],
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
