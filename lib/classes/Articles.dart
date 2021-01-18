import 'package:html/parser.dart' show parse;
import 'package:json_annotation/json_annotation.dart';

part 'Articles.g.dart';

@JsonSerializable()
class Articles {
  final int id;
  final DateTime date;
  final String link;
  final Title title;
  @JsonKey(name: 'jetpack_featured_media_url')
  final String imageUrl;
  final Content content;
  final Excerpt excerpt;

  const Articles(this.id, this.date, this.link, this.title, this.imageUrl,
      this.content, this.excerpt);

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

class HtmlUnescape implements JsonConverter<String, String> {
  const HtmlUnescape();

  @override
  // TODO: Such a heavy process for such a simple task
  String fromJson(String html) => parse(html).body.innerHtml;

  @override
  String toJson(String html) => html;
}
