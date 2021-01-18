import 'dart:async';
import 'dart:convert';

import 'package:Qactus/classes/Articles.dart';
import 'package:http/http.dart' as http;

class HttpFeeds {
  final _urlPosts = 'http://qactus.fr/wp-json/wp/v2/posts';
  final _urlCategories = 'http://qactus.fr/wp-json/wp/v2/categories';

  final _client = http.Client();

  Future<List<Articles>> getArticles() async {
    final response = await _client.get(_urlPosts);

    // Use the compute function to run parsePhotos in a separate isolate.
    // return compute(parseArticles, response.body);
    return parseArticles(response.body);
  }

// A function that converts a response body into a List<Photo>.
  List<Articles> parseArticles(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Articles>((json) => Articles.fromJson(json)).toList();
  }

  Future getPage(String url) async {}
}
