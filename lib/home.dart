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
        title: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 2,
                      blurRadius: 20,
                      offset: Offset(0, 3)
                  )
                ]
            ),
            height: 50,
            width: 50,
            child: Image(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/logo.png')
            )
        ),
      ),
      body: ContentList(),
    );
  }
}