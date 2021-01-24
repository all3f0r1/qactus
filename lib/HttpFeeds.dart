import 'dart:async';

import 'package:Qactus/json_processing/Article.dart';
import 'package:http/http.dart' as http;

class HttpFeeds {
  final _urlPosts = 'https://qactus.fr/wp-json/wp/v2/posts'
      '?_fields=id,date,link,title.rendered,jetpack_featured_media_url,'
      'content.rendered,excerpt.rendered,_links.author,_links.wp:featuredmedia'
      ',_links.wp:term'
      '&_embed=author,wp:featuredmedia,wp:term';

  final _client = http.Client();

  Future<List<Article>> getArticles() async {
    final response = await _client.get(_urlPosts);

    // Use the compute function to run in a separate isolate.
    // return compute(parseArticles, response.body);
    return articleFromJson(response.body);
  }
}
