import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_collection/Model/Post.dart';
import 'dart:convert';

class PostClient {

  Future<Iterable<Post>> fetchPosts() async {
    final response =
    await http.get("https://jsonplaceholder.typicode.com/posts");

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var jsonList = (jsonDecode(response.body) as List);
      var postList = jsonList.map((i) => new Post.fromJson(i));
      return Future.value(postList);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load posts');
    }
  }
}
