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

  ArticleScreen({required this.article}) : super();

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
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Html(
              data: article.content.text,
              // TODO: those custom styles are placeholders
              style: {
                "img": Style(
                  alignment: Alignment.center,
                )
              },
              // customRender: getCustomRender(),
              onLinkTap: (url, a, b, c) async {
                if (await canLaunch(url!)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              onImageTap: (src, a, b, c) {
                print("test");
                Image.network(src!);
              },
              onImageError: (exception, stackTrace) {
                print(exception);
              },
              customRender: {
                "iframe": (RenderContext context, Widget child) {
                  //   if (attributes.length > 0) {
                  //     double? width = double.tryParse(attributes['width'] ?? "");
                  //     double? height =
                  //         double.tryParse(attributes['height'] ?? "");
                  //     print(attributes['src']);
                  //     return Container(
                  //       width: width ?? (height ?? 150) * 2,
                  //       height: height ?? (width ?? 300) / 2,
                  //       child: WebView(
                  //         initialUrl: attributes['src'],
                  //         javascriptMode: JavascriptMode.unrestricted,
                  //         //no need for scrolling gesture recognizers on embedded youtube, so set gestureRecognizers null
                  //         //on other iframe content scrolling might be necessary, so use VerticalDragGestureRecognizer
                  //         gestureRecognizers: attributes['src']!
                  //                 .contains("youtube.com/embed")
                  //             ? null
                  //             : [Factory(() => VerticalDragGestureRecognizer())]
                  //                 .toSet(),
                  //         navigationDelegate: (NavigationRequest request) async {
                  //           // //no need to load any url besides the embedded youtube url when displaying embedded youtube, so prevent url loading
                  //           // //on other iframe content allow all url loading
                  //           // if (attributes['src'].contains("youtube.com/embed")) {
                  //           //   if (!request.url.contains("youtube.com/embed")) {
                  //           //     return NavigationDecision.prevent;
                  //           //   } else {
                  //           //     return NavigationDecision.navigate;
                  //           //   }
                  //           // } else {
                  //           return NavigationDecision.navigate;
                  //           // }
                  //         },
                  //       ),
                  //     );
                  //   } else {
                  //     return Container(height: 0);
                  //   }
                }
              }),
        ),
      ),
    );
  }

  // // define all customRenders
  // Map<String, CustomRender> getCustomRender() {
  //   var customRender = HashMap<String, CustomRender>();
  //   customRender["iframe"] = getVideoCustomRender;
  //   return customRender;
  // }
  //
  // // create customRender for asset images
  // Widget getVideoCustomRender(RenderContext context, Widget parsedChild,
  //     Map<String, String> attributes, element) {
  //   return VideoPlayerScreen(url: attributes["src"]);
  // }
}
