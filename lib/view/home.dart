import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'contentList.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String json = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Container(
            width: 50,
            child: Container(
              child: Image(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/images/logo.png')
              ),
            )
        ),
      ),
      body: ContentList(),
    );
  }
}