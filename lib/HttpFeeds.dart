import 'dart:async';
import 'dart:convert';

import 'package:Qactus/classes/Articles.dart';
import 'package:http/http.dart' as http;

class HttpFeeds {
  final _urlPosts = 'https://qactus.fr/wp-json/wp/v2/posts'
      '?_fields=id,date,link,title.rendered,jetpack_featured_media_url,'
      'content.rendered,excerpt.rendered,_links.author,_links.wp:featuredmedia'
      ',_links.wp:term'
      '&_embed=author,wp:featuredmedia,wp:term';
  final _urlCategories = 'http://qactus.fr/wp-json/wp/v2/categories';

  final _client = http.Client();

  Future<List<Articles>> getArticles() async {
    final response = await _client.get(_urlPosts);

    // Use the compute function to run in a separate isolate.
    // return compute(parseArticles, response.body);
    return parseArticles(response.body);
  }

// A function that converts a response body into a List<Articles>.
  List<Articles> parseArticles(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Articles>((json) => Articles.fromJson(json)).toList();
  }
}
