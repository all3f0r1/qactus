import 'package:html/parser.dart' show parse;
import 'package:json_annotation/json_annotation.dart';

part 'Articles.g.dart';

@JsonSerializable()
class Articles {
  final int id;
  final DateTime date;
  final String url;
  final Title title;
  @JsonKey(name: 'jetpack_featured_media_url')
  final String imageUrl;
  final Content content;
  final Excerpt excerpt;
  @JsonKey(name: '_embedded')
  final Embedded embedded;

  const Articles(this.id, this.date, this.url, this.title, this.imageUrl,
      this.content, this.excerpt, this.embedded);

  factory Articles.fromJson(Map<String, dynamic> json) =>
      _$ArticlesFromJson(json);

  Map<String, dynamic> toJson() => _$ArticlesToJson(this);
}

@JsonSerializable()
class Title {
  @HtmlUnescape()
  @JsonKey(name: 'rendered')
  final String text;

  const Title(this.text);

  factory Title.fromJson(Map<String, dynamic> json) => _$TitleFromJson(json);

  Map<String, dynamic> toJson() => _$TitleToJson(this);
}

@JsonSerializable()
class Content {
  @HtmlUnescape()
  @JsonKey(name: 'rendered')
  final String text;

  const Content(this.text);

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

@JsonSerializable()
class Excerpt {
  @HtmlUnescape()
  @JsonKey(name: 'rendered')
  final String text;

  const Excerpt(this.text);

  factory Excerpt.fromJson(Map<String, dynamic> json) =>
      _$ExcerptFromJson(json);

  Map<String, dynamic> toJson() => _$ExcerptToJson(this);
}

@JsonSerializable()
class Embedded {
  final Author author;
  @JsonKey(name: 'wp:featuredmedia')
  final Medias medias;
  @JsonKey(name: 'wp:term')
  final Categories categories;

  const Embedded(this.author, this.medias, this.categories);

  factory Embedded.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}

@JsonSerializable()
class Author {
  final String href;

  const Author(this.href);

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}

@JsonSerializable()
class Medias {
  final String href;

  const Medias(this.href);

  factory Medias.fromJson(Map<String, dynamic> json) => _$MediasFromJson(json);

  Map<String, dynamic> toJson() => _$MediasToJson(this);
}

@JsonSerializable()
class Categories {
  final String href;

  const Categories(this.href);

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
}

class HtmlUnescape implements JsonConverter<String, String> {
  const HtmlUnescape();

  @override
  // TODO: Such a heavy process for such a simple task
  String fromJson(String html) => parse(html).body.innerHtml;

  @override
  String toJson(String html) => html;
}
