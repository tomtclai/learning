// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
      json['userId'] as int, json['title'] as String, json['body'] as String);
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'userId': instance.userId,
      'title': instance.title,
      'body': instance.body
    };
