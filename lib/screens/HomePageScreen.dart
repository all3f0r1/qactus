import 'package:Qactus/json_processing/Article.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:transparent_image/transparent_image.dart';

import '../HttpFeeds.dart';
import 'ErrorScreen.dart';
import 'LoadingScreen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var unescape = HtmlUnescape();

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
            title: Text(
              'QActus',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
          ),
          body: RefreshIndicator(
            key: refreshKey,
            onRefresh: refreshList,
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
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => ArticleScreen(articles[index].link),
//                            ),
//                          );
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
        );
      },
    );
  }

  Future refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      HttpFeeds().getArticles();
    });
  }
}
