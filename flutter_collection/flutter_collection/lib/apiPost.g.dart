// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiPost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
      json['userid'] as int, json['title'] as String, json['body'] as String);
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'userid': instance.userid,
      'title': instance.title,
      'body': instance.body
    };
