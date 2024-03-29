import 'dart:async';

import 'package:Qactus/json_processing/Article.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpFeeds {
  final _client = http.Client();
  final _urlPosts = 'https://qactus.fr/wp-json/wp/v2/posts'
      '?_embed=author,wp:term'
      '&_fields=id,date,link,title.rendered,jetpack_featured_media_url,'
      'content.rendered,excerpt.rendered,_links.author,_links.wp:term'
      '&page=';

  Future<List<Article>> getArticles(int page) async {
    Uri uri = Uri.parse(_urlPosts + page.toString());
    final response = await _client.get(uri);

    // Compute function to run in a separate isolate (ie thread)
    return compute(articleFromJson, response.body);
  }

  // TODO: impl getArticlesByCategory() etc...

  // TODO: and what about a SQLite local database for caching?

  // TODO: search is done using this: https://stackoverflow.com/questions/38084765/wordpress-rest-api-global-search-api-v2
}
