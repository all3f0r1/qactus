import 'package:Qactus/json_processing/Article.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:package_info/package_info.dart';

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

  Future<List<Article>> _articles;

  @override
  void initState() {
    super.initState();
    _loadArticles();
    // TODO: put the following in the proper section
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
                    title: Text(
                      "Options",
                      style: _drawerFontStyle(),
                    ),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      "A propos",
                      style: _drawerFontStyle(),
                    ),
                    leading: Icon(Icons.alternate_email),
                    onTap: () {
                      PackageInfo.fromPlatform()
                          .then((PackageInfo packageInfo) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AboutDialog(
                              applicationName: "Qactus",
                              applicationVersion: packageInfo.version +
                                  " build number " +
                                  packageInfo.buildNumber,
                              applicationIcon: Image.asset("assets/header.png"),
                              children: [
                                Text("Conçu par Alexandre Tournai"),
                                Divider(),
                                RaisedButton(
                                  onPressed: () async {
                                    final Email email = Email(
                                      subject: 'App Qactus',
                                      recipients: [
                                        'tournai.alexandre@gmail.com'
                                      ],
                                      isHTML: false,
                                    );
                                    await FlutterEmailSender.send(email);
                                  },
                                  child: Text("Me contacter"),
                                )
                              ],
                            ),
                          ),
                        );
                      });
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
            child: NotificationListener<ScrollNotification>(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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

  void _loadArticles() async {
    _articles = HttpFeeds().getArticles();
  }

  TextStyle _drawerFontStyle() {
    return TextStyle(
      fontSize: 18,
      color: Color.fromRGBO(119, 119, 119, 1),
    );
  }
}
