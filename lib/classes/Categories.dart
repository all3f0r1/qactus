import 'package:json_annotation/json_annotation.dart';

part 'Categories.g.dart';

@JsonSerializable()
class Categories {
  final int id;
  final String name;
  final int count;
  @JsonKey(name: '_links')
  final Links links;

  const Categories(this.id, this.name, this.count, this.links);

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
}

@JsonSerializable()
class Links {
  final Self self;
  final Posts posts;

  const Links(this.self, this.posts);

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}

@JsonSerializable()
class Self {
  @JsonKey(name: 'href')
  final String link;

  const Self(this.link);

  factory Self.fromJson(Map<String, dynamic> json) => _$SelfFromJson(json);

  Map<String, dynamic> toJson() => _$SelfToJson(this);
}

@JsonSerializable()
class Posts {
  @JsonKey(name: 'href')
  final String link;

  const Posts(this.link);

  factory Posts.fromJson(Map<String, dynamic> json) => _$PostsFromJson(json);

  Map<String, dynamic> toJson() => _$PostsToJson(this);
}
