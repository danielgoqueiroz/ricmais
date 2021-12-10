import 'package:flutter/material.dart';
import 'package:ndmais/post_model.dart';
import 'contentList.dart';

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
      appBar: AppBar(
        title: Text(post.title.rendered)
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Expanded(
              child: Image.network(
                post.image,
                fit: BoxFit.fitHeight,
                height: 200,
                width: 200,
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Text(post.title.rendered, style: TextStyle(fontSize: 20))
          ),
          Expanded(
              flex: 6,
              child: Text(post.title.rendered, style: TextStyle(fontSize: 20))
          ),
        ],
      ),
    );
  }
}