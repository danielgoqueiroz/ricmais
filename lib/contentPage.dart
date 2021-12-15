import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ndmais/post_model.dart';

class MyContentPage extends StatefulWidget {
  MyContentPage({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  _MyHomePageState createState() => _MyHomePageState(this.post);
}

class _MyHomePageState extends State<MyContentPage> {
  final Post post;

  _MyHomePageState(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.date)),
      body: Container(
          child: SingleChildScrollView(
        child: Column(children: [
          Container(
              child: Stack(children: [
            Container(
                child: Image.network(
              post.image,
              fit: BoxFit.fitWidth,
            )),
            Container(
              child: Text(post.title.rendered,
                  style: TextStyle(fontSize: 24, color: Colors.white, shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ])),
            ),
          ])),
          Container(child: Html(data: post.content.rendered)),
        ]),
      )),
    );
  }
}
