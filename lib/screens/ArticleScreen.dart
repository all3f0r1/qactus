import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;

import '../HttpFeeds.dart';
import 'ErrorScreen.dart';
import 'LoadingScreen.dart';

class ArticleScreen extends StatefulWidget {
  final String _url;

  ArticleScreen([this._url]);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final RegExp _regexDate = new RegExp(r'on (.+) at');
  final RegExp _regexTime = new RegExp(r'(\d{1,2}:\d{1,2} (AM|PM) EDT)');
  final RegExp _regexForumLink = new RegExp(r'href="(\/forums.+)">');
  final RegExp _regexForumNbComments =
      new RegExp(r'href="\/forums.+">(.+)<\/a>');
  final RegExp _regexImageLink = new RegExp(r'<img.+src="(.+)" width');
  Future _future;

  @override
  void initState() {
    super.initState();
    _future = HttpFeeds().getPage(widget._url);
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

        var article =
            parser.parse(snapshot.data).body.getElementsByClassName("full")[0];
        var header = article.getElementsByClassName("author")[0].innerHtml;
        var title = article.getElementsByTagName("header")[0].innerHtml;
        var date = _regexDate.firstMatch(header).group(1);
        var time = _regexTime.firstMatch(header).group(1);
        var forumLink = "http://www.qactus.com/" +
            _regexForumLink.firstMatch(header).group(1);
        var forumNbComments = _regexForumNbComments.firstMatch(header).group(1);

        var body = article.getElementsByClassName("content")[0];
        var image = "http://www.qactus.com/" +
            _regexImageLink.firstMatch(body.outerHtml).group(1);
        var content = body.outerHtml;

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
                  title,
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
                  date + " @ " + time,
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Image.network(
                image,
                width: 100,
                height: 100,
              ),
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
