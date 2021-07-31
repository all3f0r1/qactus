import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:html_unescape/html_unescape.dart';

final unescape = HtmlUnescape();

List<Article> articleFromJson(String str) =>
    List<Article>.from(json.decode(str).map((x) => Article.fromJson(x)));

String articleToJson(List<Article> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Article {
  Article({
    required this.id,
    required this.date,
    required this.url,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.imageUrl,
    required this.embedded,
  });

  final int id;
  final DateTime date;
  final String url;
  final Title title;
  final Content content;
  final Excerpt excerpt;
  final String imageUrl;
  final Embedded embedded;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        url: json["link"] == null ? null : json["link"],
        title: Title.fromJson(json["title"]),
        content: Content.fromJson(json["content"]),
        excerpt: Excerpt.fromJson(json["excerpt"]),
        imageUrl: json["jetpack_featured_media_url"],
        embedded: Embedded.fromJson(json["_embedded"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date.toIso8601String(),
        "link": url,
        "title": title.toJson(),
        "content": content.toJson(),
        "excerpt": excerpt.toJson(),
        "jetpack_featured_media_url": imageUrl,
        "_embedded": embedded.toJson(),
      };
}

class Title {
  Title({
    required this.text,
  });

  final String text;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        text: unescape.convert(json["rendered"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "rendered": text,
      };
}

class Content {
  Content({
    required this.text,
  });

  final String text;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        text: json["rendered"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": text,
      };
}

class Excerpt {
  Excerpt({
    required this.text,
  });

  final String text;

  factory Excerpt.fromJson(Map<String, dynamic> json) => Excerpt(
        text: unescape.convert(
          json["rendered"]
              .toString()
              .replaceFirst(new RegExp(r'<a href(.+)<\/p>'), '')
              .replaceFirst("<p>", ""),
        ),
      );

  Map<String, dynamic> toJson() => {
        "rendered": text,
      };
}

class Embedded {
  Embedded({
    required this.author,
    required this.wpTerm,
  });

  final List<EmbeddedAuthor> author;
  final List<List<EmbeddedWpTerm>> wpTerm;

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
        author: List<EmbeddedAuthor>.from(
            json["author"].map((x) => EmbeddedAuthor.fromJson(x))),
        wpTerm: List<List<EmbeddedWpTerm>>.from(json["wp:term"].map((x) =>
            List<EmbeddedWpTerm>.from(
                x.map((x) => EmbeddedWpTerm.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "author": List<dynamic>.from(author.map((x) => x.toJson())),
        "wp:term": List<dynamic>.from(
            wpTerm.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

class EmbeddedAuthor {
  EmbeddedAuthor({
    required this.id,
    required this.name,
    required this.url,
    required this.description,
    required this.link,
    required this.slug,
    required this.avatarUrls,
    required this.ampDevToolsEnabled,
    required this.links,
  });

  final int id;
  final String name;
  final String url;
  final String description;
  final String link;
  final String slug;
  final Map<String, String> avatarUrls;
  final bool ampDevToolsEnabled;
  final AuthorLinks links;

  factory EmbeddedAuthor.fromJson(Map<String, dynamic> json) => EmbeddedAuthor(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        description: json["description"],
        link: json["link"],
        slug: json["slug"],
        avatarUrls: Map.from(json["avatar_urls"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        ampDevToolsEnabled: json["amp_dev_tools_enabled"],
        links: AuthorLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "description": description,
        "link": link,
        "slug": slug,
        "avatar_urls":
            Map.from(avatarUrls).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "amp_dev_tools_enabled": ampDevToolsEnabled,
        "_links": links.toJson(),
      };
}

class AuthorLinks {
  AuthorLinks({
    required this.self,
    required this.collection,
  });

  final List<Collection> self;
  final List<Collection> collection;

  factory AuthorLinks.fromJson(Map<String, dynamic> json) => AuthorLinks(
        self: List<Collection>.from(
            json["self"].map((x) => Collection.fromJson(x))),
        collection: List<Collection>.from(
            json["collection"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": List<dynamic>.from(self.map((x) => x.toJson())),
        "collection": List<dynamic>.from(collection.map((x) => x.toJson())),
      };
}

class Collection {
  Collection({
    required this.href,
  });

  final String href;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

enum MimeType { IMAGE_JPEG }

final mimeTypeValues = EnumValues({"image/jpeg": MimeType.IMAGE_JPEG});

class EmbeddedWpTerm {
  EmbeddedWpTerm({
    required this.id,
    required this.name,
    required this.links,
  });

  final int id;
  final String name;
  final WpTermLinks links;

  factory EmbeddedWpTerm.fromJson(Map<String, dynamic> json) => EmbeddedWpTerm(
        id: json["id"],
        name: json["name"],
        links: WpTermLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "_links": links.toJson(),
      };
}

class WpTermLinks {
  WpTermLinks({
    required this.wpPostType,
  });

  final List<Collection> wpPostType;

  factory WpTermLinks.fromJson(Map<String, dynamic> json) => WpTermLinks(
        wpPostType: List<Collection>.from(
            json["wp:post_type"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wp:post_type": List<dynamic>.from(wpPostType.map((x) => x.toJson())),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
