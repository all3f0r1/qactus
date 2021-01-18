import 'package:Qactus/classes/Articles.dart';
import 'package:flutter/material.dart';

import '../HttpFeeds.dart';
import 'LoadingScreen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Articles>>(
      future: HttpFeeds().getArticles(),
      builder: (builder, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return LoadingScreen();
        } else if (!snapshot.hasData) {
          return LoadingScreen();
        } else if (snapshot.data.length == 0) {
          return LoadingScreen();
        }

        return Scaffold(
          appBar: AppBar(
            // title: Image.asset(
            //   "assets/header.png",
            //   scale: 0.3,
            // ),
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
                Articles item = snapshot.data[index];
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
//                            Visibility(
//                              visible: isSooner,
//                              child: Container(
//                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
//                                child: Text(
//                                  _dateFormatOutput.format(date),
//                                  style: TextStyle(fontWeight: FontWeight.bold),
//                                ),
//                              ),
//                            ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            item.title.text,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0,
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
