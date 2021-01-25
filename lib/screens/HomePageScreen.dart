import 'package:Qactus/json_processing/Article.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../HttpFeeds.dart';
import 'ArticleScreen.dart';
import 'ErrorScreen.dart';
import 'LoadingScreen.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  WhyFarther _selection;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: HttpFeeds().getArticles(),
      builder: (builder, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        } else if (!snapshot.hasData) {
          return LoadingScreen();
        }

        return Scaffold(
          appBar: AppBar(
            leading: PopupMenuButton<WhyFarther>(
              icon: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              ),
              onSelected: (WhyFarther result) {
                setState(() {
                  _selection = result;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<WhyFarther>>[
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.harder,
                  child: Text('Working a lot harder'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.smarter,
                  child: Text('Being a lot smarter'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.selfStarter,
                  child: Text('Being a self-starter'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.tradingCharter,
                  child: Text('Placed in charge of trading charter'),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                // TODO: add search functionality here
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
            // TODO: Pagination: https://developer.wordpress.org/rest-api/using-the-rest-api/pagination/
            child: ListView.builder(
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
                            // TODO: Excerpt isn't always well-displayed
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
}
