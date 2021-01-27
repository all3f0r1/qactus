import 'package:Qactus/json_processing/Article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:share/share.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;

  ArticleScreen({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => Share.share(article.url),
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
      // body: ListView(
      //   padding: EdgeInsets.symmetric(horizontal: 8.0),
      //   children: <Widget>[
      //     Container(
      //       padding: EdgeInsets.symmetric(vertical: 5.0),
      //       // TODO: HtmlWidget is *SO* heavy and "magic"
      //       child: HtmlWidget(
      //         article.content.text,
      //       ),
      //     ),
      //     Container(
      //       alignment: Alignment.topRight,
      //       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      //       child: Text(
      //         "DATE",
      //         style: TextStyle(
      //           fontWeight: FontWeight.w200,
      //           color: Colors.black,
      //           fontSize: 14.0,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Html(
          data: article.content.text,
          // TODO: those custom styles are placeholders
          style: {
            "html": Style(
              backgroundColor: Colors.black12,
//              color: Colors.white,
            ),
//            "h1": Style(
//              textAlign: TextAlign.center,
//            ),
            "table": Style(
              backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
            ),
            "tr": Style(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            "th": Style(
              padding: EdgeInsets.all(6),
              backgroundColor: Colors.grey,
            ),
            "td": Style(
              padding: EdgeInsets.all(6),
              alignment: Alignment.topLeft,
            ),
            "var": Style(fontFamily: 'serif'),
          },
          customRender: {
            "flutter": (RenderContext context, Widget child, attributes, _) {
              return FlutterLogo(
                style: (attributes['horizontal'] != null)
                    ? FlutterLogoStyle.horizontal
                    : FlutterLogoStyle.markOnly,
                textColor: context.style.color,
                size: context.style.fontSize.size * 5,
              );
            },
          },
          onLinkTap: (url) {
            print("Opening $url...");
          },
          onImageTap: (src) {
            print(src);
          },
          onImageError: (exception, stackTrace) {
            print(exception);
          },
        ),
      ),
    );
  }
}
