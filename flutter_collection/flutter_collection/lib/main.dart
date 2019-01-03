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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

  void _incrementCounter() {
    setState(() {
      _counter++;
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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.transparent,
                  child: new InkWell(
                    onTap: () {
                      print("tapped");
                    },
                    splashColor: Colors.purple,
                    highlightColor: Colors.amber,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _posts[index].title,
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(_posts[index].body, softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 6,)
                      ],
                    ),
                  ),
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
