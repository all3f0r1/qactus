import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';

var unescape = HtmlUnescape();

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
            : unescape
                .convert(json["rendered"].toString())
                .split('…')
                .first
                .replaceFirst("<p>", ""),
      );

  Map<String, dynamic> toJson() => {
        "rendered": text == null ? null : text,
      };
}

class Embedded {
  Embedded({
    this.author,
    this.wpFeaturedmedia,
    this.wpTerm,
  });

  final List<EmbeddedAuthor> author;
  final List<WpFeaturedmedia> wpFeaturedmedia;
  final List<List<EmbeddedWpTerm>> wpTerm;

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
        author: json["author"] == null
            ? null
            : List<EmbeddedAuthor>.from(
                json["author"].map((x) => EmbeddedAuthor.fromJson(x))),
        wpFeaturedmedia: json["wp:featuredmedia"] == null
            ? null
            : List<WpFeaturedmedia>.from(json["wp:featuredmedia"]
                .map((x) => WpFeaturedmedia.fromJson(x))),
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
        "wp:featuredmedia": wpFeaturedmedia == null
            ? null
            : List<dynamic>.from(wpFeaturedmedia.map((x) => x.toJson())),
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

class WpFeaturedmedia {
  WpFeaturedmedia({
    this.id,
    this.date,
    this.slug,
    this.type,
    this.link,
    this.title,
    this.author,
    this.jetpackLikesEnabled,
    this.jetpackSharingEnabled,
    this.jetpackShortlink,
    this.ampValidity,
    this.ampEnabled,
    this.caption,
    this.altText,
    this.mediaType,
    this.mimeType,
    this.mediaDetails,
    this.sourceUrl,
    this.links,
  });

  final int id;
  final DateTime date;
  final String slug;
  final String type;
  final String link;
  final Content title;
  final int author;
  final bool jetpackLikesEnabled;
  final bool jetpackSharingEnabled;
  final String jetpackShortlink;
  final dynamic ampValidity;
  final bool ampEnabled;
  final Content caption;
  final String altText;
  final String mediaType;
  final MimeType mimeType;
  final MediaDetails mediaDetails;
  final String sourceUrl;
  final WpFeaturedmediaLinks links;

  factory WpFeaturedmedia.fromJson(Map<String, dynamic> json) =>
      WpFeaturedmedia(
        id: json["id"] == null ? null : json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        slug: json["slug"] == null ? null : json["slug"],
        type: json["type"] == null ? null : json["type"],
        link: json["link"] == null ? null : json["link"],
        title: json["title"] == null ? null : Content.fromJson(json["title"]),
        author: json["author"] == null ? null : json["author"],
        jetpackLikesEnabled: json["jetpack_likes_enabled"] == null
            ? null
            : json["jetpack_likes_enabled"],
        jetpackSharingEnabled: json["jetpack_sharing_enabled"] == null
            ? null
            : json["jetpack_sharing_enabled"],
        jetpackShortlink: json["jetpack_shortlink"] == null
            ? null
            : json["jetpack_shortlink"],
        ampValidity: json["amp_validity"],
        ampEnabled: json["amp_enabled"] == null ? null : json["amp_enabled"],
        caption:
            json["caption"] == null ? null : Content.fromJson(json["caption"]),
        altText: json["alt_text"] == null ? null : json["alt_text"],
        mediaType: json["media_type"] == null ? null : json["media_type"],
        mimeType: json["mime_type"] == null
            ? null
            : mimeTypeValues.map[json["mime_type"]],
        mediaDetails: json["media_details"] == null
            ? null
            : MediaDetails.fromJson(json["media_details"]),
        sourceUrl: json["source_url"] == null ? null : json["source_url"],
        links: json["_links"] == null
            ? null
            : WpFeaturedmediaLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "date": date == null ? null : date.toIso8601String(),
        "slug": slug == null ? null : slug,
        "type": type == null ? null : type,
        "link": link == null ? null : link,
        "title": title == null ? null : title.toJson(),
        "author": author == null ? null : author,
        "jetpack_likes_enabled":
            jetpackLikesEnabled == null ? null : jetpackLikesEnabled,
        "jetpack_sharing_enabled":
            jetpackSharingEnabled == null ? null : jetpackSharingEnabled,
        "jetpack_shortlink": jetpackShortlink == null ? null : jetpackShortlink,
        "amp_validity": ampValidity,
        "amp_enabled": ampEnabled == null ? null : ampEnabled,
        "caption": caption == null ? null : caption.toJson(),
        "alt_text": altText == null ? null : altText,
        "media_type": mediaType == null ? null : mediaType,
        "mime_type": mimeType == null ? null : mimeTypeValues.reverse[mimeType],
        "media_details": mediaDetails == null ? null : mediaDetails.toJson(),
        "source_url": sourceUrl == null ? null : sourceUrl,
        "_links": links == null ? null : links.toJson(),
      };
}

class WpFeaturedmediaLinks {
  WpFeaturedmediaLinks({
    this.self,
    this.collection,
    this.about,
    this.author,
  });

  final List<Collection> self;
  final List<Collection> collection;
  final List<Collection> about;
  final List<WpFeaturedmediaElement> author;

  factory WpFeaturedmediaLinks.fromJson(Map<String, dynamic> json) =>
      WpFeaturedmediaLinks(
        self: json["self"] == null
            ? null
            : List<Collection>.from(
                json["self"].map((x) => Collection.fromJson(x))),
        collection: json["collection"] == null
            ? null
            : List<Collection>.from(
                json["collection"].map((x) => Collection.fromJson(x))),
        about: json["about"] == null
            ? null
            : List<Collection>.from(
                json["about"].map((x) => Collection.fromJson(x))),
        author: json["author"] == null
            ? null
            : List<WpFeaturedmediaElement>.from(
                json["author"].map((x) => WpFeaturedmediaElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? null
            : List<dynamic>.from(self.map((x) => x.toJson())),
        "collection": collection == null
            ? null
            : List<dynamic>.from(collection.map((x) => x.toJson())),
        "about": about == null
            ? null
            : List<dynamic>.from(about.map((x) => x.toJson())),
        "author": author == null
            ? null
            : List<dynamic>.from(author.map((x) => x.toJson())),
      };
}

class WpFeaturedmediaElement {
  WpFeaturedmediaElement({
    this.embeddable,
    this.href,
  });

  final bool embeddable;
  final String href;

  factory WpFeaturedmediaElement.fromJson(Map<String, dynamic> json) =>
      WpFeaturedmediaElement(
        embeddable: json["embeddable"] == null ? null : json["embeddable"],
        href: json["href"] == null ? null : json["href"],
      );

  Map<String, dynamic> toJson() => {
        "embeddable": embeddable == null ? null : embeddable,
        "href": href == null ? null : href,
      };
}

class MediaDetails {
  MediaDetails({
    this.width,
    this.height,
    this.file,
    this.sizes,
    this.imageMeta,
  });

  final int width;
  final int height;
  final String file;
  final Map<String, Size> sizes;
  final ImageMeta imageMeta;

  factory MediaDetails.fromJson(Map<String, dynamic> json) => MediaDetails(
        width: json["width"] == null ? null : json["width"],
        height: json["height"] == null ? null : json["height"],
        file: json["file"] == null ? null : json["file"],
        sizes: json["sizes"] == null
            ? null
            : Map.from(json["sizes"])
                .map((k, v) => MapEntry<String, Size>(k, Size.fromJson(v))),
        imageMeta: json["image_meta"] == null
            ? null
            : ImageMeta.fromJson(json["image_meta"]),
      );

  Map<String, dynamic> toJson() => {
        "width": width == null ? null : width,
        "height": height == null ? null : height,
        "file": file == null ? null : file,
        "sizes": sizes == null
            ? null
            : Map.from(sizes)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "image_meta": imageMeta == null ? null : imageMeta.toJson(),
      };
}

class ImageMeta {
  ImageMeta({
    this.aperture,
    this.credit,
    this.camera,
    this.caption,
    this.createdTimestamp,
    this.copyright,
    this.focalLength,
    this.iso,
    this.shutterSpeed,
    this.title,
    this.orientation,
    this.keywords,
  });

  final String aperture;
  final String credit;
  final String camera;
  final String caption;
  final String createdTimestamp;
  final String copyright;
  final String focalLength;
  final String iso;
  final String shutterSpeed;
  final String title;
  final String orientation;
  final List<dynamic> keywords;

  factory ImageMeta.fromJson(Map<String, dynamic> json) => ImageMeta(
        aperture: json["aperture"] == null ? null : json["aperture"],
        credit: json["credit"] == null ? null : json["credit"],
        camera: json["camera"] == null ? null : json["camera"],
        caption: json["caption"] == null ? null : json["caption"],
        createdTimestamp: json["created_timestamp"] == null
            ? null
            : json["created_timestamp"],
        copyright: json["copyright"] == null ? null : json["copyright"],
        focalLength: json["focal_length"] == null ? null : json["focal_length"],
        iso: json["iso"] == null ? null : json["iso"],
        shutterSpeed:
            json["shutter_speed"] == null ? null : json["shutter_speed"],
        title: json["title"] == null ? null : json["title"],
        orientation: json["orientation"] == null ? null : json["orientation"],
        keywords: json["keywords"] == null
            ? null
            : List<dynamic>.from(json["keywords"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "aperture": aperture == null ? null : aperture,
        "credit": credit == null ? null : credit,
        "camera": camera == null ? null : camera,
        "caption": caption == null ? null : caption,
        "created_timestamp": createdTimestamp == null ? null : createdTimestamp,
        "copyright": copyright == null ? null : copyright,
        "focal_length": focalLength == null ? null : focalLength,
        "iso": iso == null ? null : iso,
        "shutter_speed": shutterSpeed == null ? null : shutterSpeed,
        "title": title == null ? null : title,
        "orientation": orientation == null ? null : orientation,
        "keywords": keywords == null
            ? null
            : List<dynamic>.from(keywords.map((x) => x)),
      };
}

class Size {
  Size({
    this.path,
    this.file,
    this.width,
    this.height,
    this.mimeType,
    this.sourceUrl,
  });

  final String path;
  final String file;
  final int width;
  final int height;
  final MimeType mimeType;
  final String sourceUrl;

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        path: json["path"] == null ? null : json["path"],
        file: json["file"] == null ? null : json["file"],
        width: json["width"] == null ? null : json["width"],
        height: json["height"] == null ? null : json["height"],
        mimeType: json["mime_type"] == null
            ? null
            : mimeTypeValues.map[json["mime_type"]],
        sourceUrl: json["source_url"] == null ? null : json["source_url"],
      );

  Map<String, dynamic> toJson() => {
        "path": path == null ? null : path,
        "file": file == null ? null : file,
        "width": width == null ? null : width,
        "height": height == null ? null : height,
        "mime_type": mimeType == null ? null : mimeTypeValues.reverse[mimeType],
        "source_url": sourceUrl == null ? null : sourceUrl,
      };
}

enum MimeType { IMAGE_JPEG }

final mimeTypeValues = EnumValues({"image/jpeg": MimeType.IMAGE_JPEG});

class EmbeddedWpTerm {
  EmbeddedWpTerm({
    this.id,
    this.link,
    this.name,
    this.slug,
    this.taxonomy,
    this.links,
  });

  final int id;
  final String link;
  final String name;
  final String slug;
  final String taxonomy;
  final WpTermLinks links;

  factory EmbeddedWpTerm.fromJson(Map<String, dynamic> json) => EmbeddedWpTerm(
        id: json["id"] == null ? null : json["id"],
        link: json["link"] == null ? null : json["link"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        taxonomy: json["taxonomy"] == null ? null : json["taxonomy"],
        links: json["_links"] == null
            ? null
            : WpTermLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "link": link == null ? null : link,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "taxonomy": taxonomy == null ? null : taxonomy,
        "_links": links == null ? null : links.toJson(),
      };
}

class WpTermLinks {
  WpTermLinks({
    this.self,
    this.collection,
    this.about,
    this.wpPostType,
  });

  final List<Collection> self;
  final List<Collection> collection;
  final List<Collection> about;
  final List<Collection> wpPostType;

  factory WpTermLinks.fromJson(Map<String, dynamic> json) => WpTermLinks(
        self: json["self"] == null
            ? null
            : List<Collection>.from(
                json["self"].map((x) => Collection.fromJson(x))),
        collection: json["collection"] == null
            ? null
            : List<Collection>.from(
                json["collection"].map((x) => Collection.fromJson(x))),
        about: json["about"] == null
            ? null
            : List<Collection>.from(
                json["about"].map((x) => Collection.fromJson(x))),
        wpPostType: json["wp:post_type"] == null
            ? null
            : List<Collection>.from(
                json["wp:post_type"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? null
            : List<dynamic>.from(self.map((x) => x.toJson())),
        "collection": collection == null
            ? null
            : List<dynamic>.from(collection.map((x) => x.toJson())),
        "about": about == null
            ? null
            : List<dynamic>.from(about.map((x) => x.toJson())),
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
