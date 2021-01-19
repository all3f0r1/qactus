import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../HttpFeeds.dart';
import 'ErrorScreen.dart';
import 'LoadingScreen.dart';

class ArticleScreen extends StatefulWidget {
  ArticleScreen();

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  Future _future;

  @override
  void initState() {
    super.initState();
    _future = HttpFeeds().getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        } else if (!snapshot.hasData) {
          return LoadingScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: Image.asset(
              "assets/header.png",
              scale: 1.3,
            ),
            backgroundColor: Colors.white,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "TITLE",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                child: Text(
                  "DATE",
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
              // Image.network(
              //   image,
              //   width: 100,
              //   height: 100,
              // ),
              Divider(
                thickness: 0.4,
                color: Colors.black,
              ),
            ],
          ),
        );
      },
    );
  }
}
