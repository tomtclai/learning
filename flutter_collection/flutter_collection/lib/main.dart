import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_collection/Model/Post.dart';
import 'dart:convert';
import 'API/postClient.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Post> _posts;
  @override
  void initState() {
    super.initState();
    loadPlaceholder();
  }

  void loadPlaceholder() async {
    PostClient().fetchPosts().then((posts) {
        this.setState(() {
          this._posts = posts.toList();
        });
        print(this._posts[0].title);
      });
  }

  Widget postList(List<Post> posts) {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      return new Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.transparent,
        child: new InkWell(
          onTap: () {
            print("tapped");
          },
          splashColor: Colors.purple,
          highlightColor: Colors.amber,
          child: postColumn(index),
        ),
      );
    });
  }

  Column postColumn(int index) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _posts[index].title,
          style: TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          _posts[index].body,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 6,
        )
      ],
    );
  }

  Widget postWidgetWithLoadingIndicator(List<Post> posts, bool isGrid) {
    if (posts == null) {
      return Center(child: CircularProgressIndicator(
          backgroundColor: Colors.pink),);
    } else if (isGrid) {
      return postGrid(posts);
    } else {
      return postList(posts);
    }
  }

  Widget postGrid(List<Post> posts) {

      return GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: _posts.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              padding: EdgeInsets.all(7.0),
              color: Colors.transparent,
              child: new InkWell(
                onTap: () {
                  print("tapped");
                },
                splashColor: Colors.purple,
                highlightColor: Colors.amber,
                child: postColumn(index),
              ),
            );
          });

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(tabs: [
                Tab(icon: Icon(Icons.list)),
                Tab(icon: Icon(Icons.apps)),
              ]),
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(widget.title),
            ),
            body: TabBarView(children: [
              postWidgetWithLoadingIndicator(_posts, false),
              postWidgetWithLoadingIndicator(_posts, true)
            ])));
  }
}
