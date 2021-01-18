// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Categories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Categories _$CategoriesFromJson(Map<String, dynamic> json) {
  return Categories(
    json['id'] as int,
    json['name'] as String,
    json['count'] as int,
    json['_links'] == null
        ? null
        : Links.fromJson(json['_links'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CategoriesToJson(Categories instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'count': instance.count,
      '_links': instance.links,
    };

Links _$LinksFromJson(Map<String, dynamic> json) {
  return Links(
    json['self'] == null
        ? null
        : Self.fromJson(json['self'] as Map<String, dynamic>),
    json['posts'] == null
        ? null
        : Posts.fromJson(json['posts'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LinksToJson(Links instance) => <String, dynamic>{
      'self': instance.self,
      'posts': instance.posts,
    };

Self _$SelfFromJson(Map<String, dynamic> json) {
  return Self(
    json['href'] as String,
  );
}

Map<String, dynamic> _$SelfToJson(Self instance) => <String, dynamic>{
      'href': instance.link,
    };

Posts _$PostsFromJson(Map<String, dynamic> json) {
  return Posts(
    json['href'] as String,
  );
}

Map<String, dynamic> _$PostsToJson(Posts instance) => <String, dynamic>{
      'href': instance.link,
    };
