import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ndmais/post_model.dart';
import 'contentPage.dart';

var posts;
int count = 1;

class ContentList extends StatefulWidget {
  const ContentList({Key? key}) : super(key: key);

  @override
  State<ContentList> createState() => new _DynamicList();
}

class _DynamicList extends State<ContentList> {
  int page = 0;
  List<Post> posts = <Post>[];
  ScrollController _scrollController = new ScrollController();

  @override
  initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 100) {
        getPosts();
      }
    });

    getPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.blue,
            ),
        controller: _scrollController,
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          var post = posts[index];
          var image = Image.network(
            post.image,
            fit: BoxFit.fill,
          );
          return ListTile(
            onTap: () {
              Navigator.of(context).push(_createRoute(post));
            },
            title: getTile(post, image, context),
            trailing: const Icon(Icons.keyboard_arrow_right),
          );
        });
  }

  getPosts() async {
    var json = await rootBundle.loadString('assets/posts.json');
    var jsonArray = List.from(jsonDecode(json));
      jsonArray.forEach((_item) {
        Post post = Post.fromJson(_item);
        setState(() {
          posts.add(post);
          posts.toSet().toList();
        });
      });

    // this.page = page + 1;
    // String url = "https://ndmais.com.br/wp-json/wp/v2/posts?per_page=5&page=" +
    //     page.toString() +
    //     "&_embed&tags_exclude=222683";

    // var response = await http.get(Uri.parse(url));
    // if (response.statusCode == 200) {
    //   var json = response.body;
    //   var jsonArray = List.from(jsonDecode(json));
    //   jsonArray.forEach((_item) {
    //     Post post = Post.fromJson(_item);
    //     setState(() {
    //       posts.add(post);
    //       posts.toSet().toList();
    //     });
    //   });
    // } else {
    //   throw Exception('Falha ao carregar posts');
    // }
  }

  Column getTile(Post post, Image image, BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.topLeft,
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
            text: post.category.toUpperCase(),
            style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: " | ",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black45,
            ),
          ),
          TextSpan(
            text: getDate(post.date),
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          )
        ])),
      ),
      Stack(
        children: getImageList(post, image),
      ),
      RichText(
          text: TextSpan(children: [
        TextSpan(
          text: post.excerpt.rendered,
          style: DefaultTextStyle.of(context).style,
        ),
        TextSpan(
          text: " Ver mais.",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )
      ])),
    ]);
  }

  List<Widget> getImageList(Post post, Image image) {
    var isImageValid = post.image.length > 0;

    if (isImageValid) {
      return [
        image,
        Positioned.fill(
            child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.all(8),
            child: Text(
              post.title.rendered,
              style: TextStyle(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  fontSize: 20,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ]),
            ),
          ),
        ))
      ];
    } else {
      return [
        Text(
          post.title.rendered,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        )
      ];
    }
  }

  getDate(String dateText) {
    if (dateText.length == 0) {
      return "";
    }
    var formatInput = new DateFormat("yyyy-MM-dd'T'HH:mm:ss", "pt_BR");
    var formatOutput = new DateFormat.yMMMMEEEEd("pt_BR");

    var date = formatInput.parse(dateText);
    var dateTextOutput = formatOutput.format(date);
    return dateTextOutput;
  }

  Route _createRoute(Post post) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MyContentPage(post: post),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    });
  }
}
