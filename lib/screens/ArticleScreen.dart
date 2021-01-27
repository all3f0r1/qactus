import 'package:Qactus/json_processing/Article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: SingleChildScrollView(
        child: Html(
          data: article.content.text,
          // TODO: those custom styles are placeholders
          style: {
            //  "html": Style(
            //    backgroundColor: Colors.black12,
            //   color: Colors.white,
            //  ),
            // "h1": Style(
            //   textAlign: TextAlign.center,
            // ),
            "img": Style(
              alignment: Alignment.center,
            )
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
          onLinkTap: (url) async {
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          onImageTap: (src) {
            Image.network(src);
          },
          onImageError: (exception, stackTrace) {
            print(exception);
          },
        ),
      ),
    );
  }
}
