import 'package:Qactus/json_processing/Article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;

  ArticleScreen({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            // TODO: add search functionality here
            onPressed: () => AlertDialog(
              title: Text('Partage'),
              content: Text('Bientôt ici les partages'),
            ),
          ),
        ],
        title: Text(
          article.title.text,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(232, 8, 50, 1),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            // TODO: HtmlWidget is *SO* heavy and "magic"
            child: HtmlWidget(
              article.content.text,
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
        ],
      ),
    );
  }
}
