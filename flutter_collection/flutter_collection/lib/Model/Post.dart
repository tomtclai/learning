import 'package:json_annotation/json_annotation.dart';

part 'package:flutter_collection/Model/Post.g.dart';

@JsonSerializable()

class Post {
  Post(this.userId, this.title, this.body);

  final int userId;
  final String title;
  final String body;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
