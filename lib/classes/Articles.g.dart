// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Articles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Articles _$ArticlesFromJson(Map<String, dynamic> json) {
  return Articles(
    json['id'] as int,
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
    json['url'] as String,
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
    json['_links'] == null
        ? null
        : Embedded.fromJson(json['_links'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ArticlesToJson(Articles instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'url': instance.url,
      'title': instance.title,
      'jetpack_featured_media_url': instance.imageUrl,
      'content': instance.content,
      'excerpt': instance.excerpt,
      '_links': instance.embedded,
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

Embedded _$LinksFromJson(Map<String, dynamic> json) {
  return Embedded(
    json['author'] == null
        ? null
        : Author.fromJson(json['author'] as Map<String, dynamic>),
    json['wp:featuredmedia'] == null
        ? null
        : Medias.fromJson(json['wp:featuredmedia'] as Map<String, dynamic>),
    json['wp:term'] == null
        ? null
        : Categories.fromJson(json['wp:term'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LinksToJson(Embedded instance) => <String, dynamic>{
      'author': instance.author,
      'wp:featuredmedia': instance.medias,
      'wp:term': instance.categories,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) {
  return Author(
    json['href'] as String,
  );
}

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'href': instance.href,
    };

Medias _$MediasFromJson(Map<String, dynamic> json) {
  return Medias(
    json['href'] as String,
  );
}

Map<String, dynamic> _$MediasToJson(Medias instance) => <String, dynamic>{
      'href': instance.href,
    };

Categories _$CategoriesFromJson(Map<String, dynamic> json) {
  return Categories(
    json['href'] as String,
  );
}

Map<String, dynamic> _$CategoriesToJson(Categories instance) =>
    <String, dynamic>{
      'href': instance.href,
    };
