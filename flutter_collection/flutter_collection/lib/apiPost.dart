import 'package:json_annotation/json_annotation.dart';

part 'apiPost.g.dart';

@JsonSerializable()

class Post {
  Post(this.userid, this.title, this.body);

  int userid;
  String title;
  String body;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
