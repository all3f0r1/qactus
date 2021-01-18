// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Articles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Articles _$ArticlesFromJson(Map<String, dynamic> json) {
  return Articles(
    json['id'] as int,
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
    json['link'] as String,
    json['title'] == null
        ? null
        : Title.fromJson(json['title'] as Map<String, dynamic>),
    json['jetpack_featured_media_url'] as String,
    json['content'] == null
        ? null
        : Content.fromJson(json['content'] as Map<String, dynamic>),
    json['excerpt'] == null
        ? null
        : Excerpt.fromJson(json['excerpt'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ArticlesToJson(Articles instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'link': instance.link,
      'title': instance.title,
      'jetpack_featured_media_url': instance.imageUrl,
      'content': instance.content,
      'excerpt': instance.excerpt,
    };

Title _$TitleFromJson(Map<String, dynamic> json) {
  return Title(
    const HtmlUnescape().fromJson(json['rendered'] as String),
  );
}

Map<String, dynamic> _$TitleToJson(Title instance) => <String, dynamic>{
      'rendered': const HtmlUnescape().toJson(instance.text),
    };

Content _$ContentFromJson(Map<String, dynamic> json) {
  return Content(
    const HtmlUnescape().fromJson(json['rendered'] as String),
  );
}

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'rendered': const HtmlUnescape().toJson(instance.text),
    };

Excerpt _$ExcerptFromJson(Map<String, dynamic> json) {
  return Excerpt(
    const HtmlUnescape().fromJson(json['rendered'] as String),
  );
}

Map<String, dynamic> _$ExcerptToJson(Excerpt instance) => <String, dynamic>{
      'rendered': const HtmlUnescape().toJson(instance.text),
    };
