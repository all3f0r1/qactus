import 'dart:async';

import 'package:Qactus/components/BottomMenu.dart';
import 'package:Qactus/components/PageTransition.dart';
import 'package:Qactus/components/SideMenu.dart';
import 'package:Qactus/json_processing/Article.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';

import '../components/HttpFeeds.dart';
import 'ArticleScreen.dart';
import 'ErrorScreen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();

  // Used for callbacks from BottomMenu
  static _HomePageScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_HomePageScreenState>();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final DateFormat _dateFormatter = DateFormat('dd-MM-yyyy');
  Future<List<Article>> _articles;

  @override
  void initState() {
    super.initState();
    _loadArticles(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: _articles,
      builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        }

        return Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: BottomMenu(callback: (page) {
              _loadArticles(page);
            }),
          ),
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
          body: Scrollbar(
            child: ListView.builder(
              itemCount: snapshot.hasData ? snapshot.data.length : 0,
              itemBuilder: (BuildContext builder, int index) {
                if (snapshot.connectionState == ConnectionState.done &&
                    EasyLoading.isShow) {
                  EasyLoading.dismiss();
                } else if (snapshot.connectionState != ConnectionState.done &&
                    !EasyLoading.isShow) {
                  // _loadingProgress = (index + 1) / snapshot.data.length;
                  EasyLoading.show(
                    status: 'Chargement...',
                    maskType: EasyLoadingMaskType.black,
                  );
                }

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
                        PageTransition(
                          ArticleScreen(article: item),
                        ),
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
                          child: AspectRatio(
                            aspectRatio: 269 / 173,
                            child: OctoImage(
                              key: Key(item.imageUrl),
                              width: MediaQuery.of(context).size.width,
                              image: CachedNetworkImageProvider(item.imageUrl),
                              placeholderBuilder:
                                  OctoPlaceholder.circularProgressIndicator(),
                              errorBuilder: OctoError.icon(color: Colors.red),
                              fit: BoxFit.fitWidth,
                            ),
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
                              fontSize: 13.0,
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

  // TODO: make transitions smoother between pages
  void _loadArticles(int page) {
    setState(() {
      _articles = HttpFeeds().getArticles(page);
    });
  }
}
