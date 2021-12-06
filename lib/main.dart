import 'dart:convert';
// import 'dart:html' as html;
// import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndmais/post_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ndmais',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'NDmais'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String json = "teste";

  Future<String> getPosts() async {
    String url =
        "https://ndmais.com.br/wp-json/wp/v2/posts?per_page=5&page=1&_embed&tags_exclude=222683";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    } else {
      throw Exception('Falha ao carregar posts');
    }
  }

  // void _update() async {
  //   setState(() async {
  //     json = await getPosts();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Container(
          child: FutureBuilder(
            future: getPosts(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data == null
                      ? 0
                      : jsonDecode(snapshot.data).length,
                  itemBuilder: (BuildContext context, int index) {
                    Post post = Post.fromJson(jsonDecode(snapshot.data)[index]);
                    return ListTile(
                      leading: Container(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            post.image,
                            fit: BoxFit.fitHeight,
                            height: 100,
                            width: 100,
                          )),
                      title: Text(post.title.rendered),
                      subtitle: Text(post.excerpt.rendered),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
