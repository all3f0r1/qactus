import 'dart:async';

import 'package:Qactus/json_processing/Article.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpFeeds {
  static final HttpFeeds _instance = HttpFeeds.initState();

  final _urlPosts = 'https://qactus.fr/wp-json/wp/v2/posts'
      '?_embed=author,wp:term'
      '&_fields=id,date,link,title.rendered,jetpack_featured_media_url,'
      'content.rendered,excerpt.rendered,_links.author,_links.wp:term'
      '&page=';
  int currentPage = 1;

  var _client = http.Client();

  factory HttpFeeds() {
    return _instance;
  }

  HttpFeeds.initState();

  Future<List<Article>> getArticles() async {
    final response = await _client.get(_urlPosts + currentPage.toString());

    // Compute function to run in a separate isolate.
    return compute(articleFromJson, response.body);
  }

  void incrementPageNumber() {
    currentPage += 1;
  }

  // TODO: impl getArticlesByCategory() etc...

  // TODO: and what about a SQLite local database for caching?

  // TODO: search is done using this: https://stackoverflow.com/questions/38084765/wordpress-rest-api-global-search-api-v2
}
