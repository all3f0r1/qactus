import 'package:Qactus/components/SideMenu.dart';
import 'package:Qactus/json_processing/Article.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';

import '../HttpFeeds.dart';
import 'ArticleScreen.dart';
import 'ErrorScreen.dart';
import 'LoadingScreen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final DateFormat _dateFormatter = DateFormat('dd-MM-yyyy');
  Future<List<Article>> _articles;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: _articles,
      builder: (builder, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        } else if (!snapshot.hasData) {
          return LoadingScreen(duration: Duration(seconds: 2));
        }

        return Scaffold(
          drawer: SideMenu(),
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
          body: NotificationListener<ScrollNotification>(
            // ignore: missing_return
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                HttpFeeds().incrementPageNumber();
                setState(() {
                  _loadArticles();
                });
              }
            },
            child: Scrollbar(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (builder, index) {
                  Article item = snapshot.data[index];
                  String categories = item.embedded.wpTerm[0]
                      .map((e) => e.name)
                      .join(', ')
                      .toUpperCase();
                  String date = _dateFormatter.format(item.date);

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
                                AspectRatio(
                                  aspectRatio: 269 / 173,
                                  child: OctoImage(
                                    width: MediaQuery.of(context).size.width,
                                    image: CachedNetworkImageProvider(
                                        item.imageUrl),
                                    placeholderBuilder: OctoPlaceholder
                                        .circularProgressIndicator(),
                                    errorBuilder:
                                        OctoError.icon(color: Colors.red),
                                    fit: BoxFit.fitWidth,
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

  // This deserved its own method because *transitions*
  Route _createRoute(Article item) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ArticleScreen(
        article: item,
      ),
      // transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //   return FadeTransition(
      //     opacity: animation,
      //     child: child,
      //   );
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  void _loadArticles() async {
    _articles = HttpFeeds().getArticles();
  }
}
