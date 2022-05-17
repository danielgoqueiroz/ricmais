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
      appBar: getAppBar(),
      body: ContentList(),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      elevation: 5,
      shadowColor: Colors.lightBlue,
      centerTitle: true,
      backgroundColor:  Color.fromRGBO(3, 45, 90, 1),
      title: getTitle(),
    );
  }

  Container getTitle() {
    return Container(width: 85, child: getLogo());
  }

  Container getLogo() {
    return Container(
      child: Image(
          fit: BoxFit.fitWidth, image: AssetImage('assets/images/logo.png')),
    );
  }
}
