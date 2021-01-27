import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';

final unescape = HtmlUnescape();

List<Article> articleFromJson(String str) =>
    List<Article>.from(json.decode(str).map((x) => Article.fromJson(x)));

String articleToJson(List<Article> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Article {
  Article({
    this.id,
    this.date,
    this.url,
    this.title,
    this.content,
    this.excerpt,
    this.imageUrl,
    this.embedded,
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
        id: json["id"] == null ? null : json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        url: json["link"] == null ? null : json["link"],
        title: json["title"] == null ? null : Title.fromJson(json["title"]),
        content:
            json["content"] == null ? null : Content.fromJson(json["content"]),
        excerpt:
            json["excerpt"] == null ? null : Excerpt.fromJson(json["excerpt"]),
        imageUrl: json["jetpack_featured_media_url"] == null
            ? null
            : json["jetpack_featured_media_url"],
        embedded: json["_embedded"] == null
            ? null
            : Embedded.fromJson(json["_embedded"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "date": date == null ? null : date.toIso8601String(),
        "link": url == null ? null : url,
        "title": title == null ? null : title.toJson(),
        "content": content == null ? null : content.toJson(),
        "excerpt": excerpt == null ? null : excerpt.toJson(),
        "jetpack_featured_media_url": imageUrl == null ? null : imageUrl,
        "_embedded": embedded == null ? null : embedded.toJson(),
      };
}

class Title {
  Title({
    this.text,
  });

  final String text;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        text: json["rendered"] == null
            ? null
            : unescape.convert(json["rendered"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "rendered": text == null ? null : text,
      };
}

class Content {
  Content({
    this.text,
  });

  final String text;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        text: json["rendered"] == null ? null : json["rendered"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": text == null ? null : text,
      };
}

class Excerpt {
  Excerpt({
    this.text,
  });

  final String text;

  factory Excerpt.fromJson(Map<String, dynamic> json) => Excerpt(
        text: json["rendered"] == null
            ? null
            : unescape.convert(
                json["rendered"]
                    .toString()
                    .replaceFirst(new RegExp(r'<a href(.+)<\/p>'), '')
                    .replaceFirst("<p>", ""),
              ),
      );

  Map<String, dynamic> toJson() => {
        "rendered": text == null ? null : text,
      };
}

class Embedded {
  Embedded({
    this.author,
    this.wpTerm,
  });

  final List<EmbeddedAuthor> author;
  final List<List<EmbeddedWpTerm>> wpTerm;

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
        author: json["author"] == null
            ? null
            : List<EmbeddedAuthor>.from(
                json["author"].map((x) => EmbeddedAuthor.fromJson(x))),
        wpTerm: json["wp:term"] == null
            ? null
            : List<List<EmbeddedWpTerm>>.from(json["wp:term"].map((x) =>
                List<EmbeddedWpTerm>.from(
                    x.map((x) => EmbeddedWpTerm.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "author": author == null
            ? null
            : List<dynamic>.from(author.map((x) => x.toJson())),
        "wp:term": wpTerm == null
            ? null
            : List<dynamic>.from(wpTerm
                .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

class EmbeddedAuthor {
  EmbeddedAuthor({
    this.id,
    this.name,
    this.url,
    this.description,
    this.link,
    this.slug,
    this.avatarUrls,
    this.ampDevToolsEnabled,
    this.links,
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
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        url: json["url"] == null ? null : json["url"],
        description: json["description"] == null ? null : json["description"],
        link: json["link"] == null ? null : json["link"],
        slug: json["slug"] == null ? null : json["slug"],
        avatarUrls: json["avatar_urls"] == null
            ? null
            : Map.from(json["avatar_urls"])
                .map((k, v) => MapEntry<String, String>(k, v)),
        ampDevToolsEnabled: json["amp_dev_tools_enabled"] == null
            ? null
            : json["amp_dev_tools_enabled"],
        links: json["_links"] == null
            ? null
            : AuthorLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "url": url == null ? null : url,
        "description": description == null ? null : description,
        "link": link == null ? null : link,
        "slug": slug == null ? null : slug,
        "avatar_urls": avatarUrls == null
            ? null
            : Map.from(avatarUrls)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "amp_dev_tools_enabled":
            ampDevToolsEnabled == null ? null : ampDevToolsEnabled,
        "_links": links == null ? null : links.toJson(),
      };
}

class AuthorLinks {
  AuthorLinks({
    this.self,
    this.collection,
  });

  final List<Collection> self;
  final List<Collection> collection;

  factory AuthorLinks.fromJson(Map<String, dynamic> json) => AuthorLinks(
        self: json["self"] == null
            ? null
            : List<Collection>.from(
                json["self"].map((x) => Collection.fromJson(x))),
        collection: json["collection"] == null
            ? null
            : List<Collection>.from(
                json["collection"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? null
            : List<dynamic>.from(self.map((x) => x.toJson())),
        "collection": collection == null
            ? null
            : List<dynamic>.from(collection.map((x) => x.toJson())),
      };
}

class Collection {
  Collection({
    this.href,
  });

  final String href;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        href: json["href"] == null ? null : json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href == null ? null : href,
      };
}

enum MimeType { IMAGE_JPEG }

final mimeTypeValues = EnumValues({"image/jpeg": MimeType.IMAGE_JPEG});

class EmbeddedWpTerm {
  EmbeddedWpTerm({
    this.id,
    this.name,
    this.links,
  });

  final int id;
  final String name;
  final WpTermLinks links;

  factory EmbeddedWpTerm.fromJson(Map<String, dynamic> json) => EmbeddedWpTerm(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        links: json["_links"] == null
            ? null
            : WpTermLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "_links": links == null ? null : links.toJson(),
      };
}

class WpTermLinks {
  WpTermLinks({
    this.wpPostType,
  });

  final List<Collection> wpPostType;

  factory WpTermLinks.fromJson(Map<String, dynamic> json) => WpTermLinks(
        wpPostType: json["wp:post_type"] == null
            ? null
            : List<Collection>.from(
                json["wp:post_type"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wp:post_type": wpPostType == null
            ? null
            : List<dynamic>.from(wpPostType.map((x) => x.toJson())),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
