import 'dart:convert';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:ndmais/model/post.dart';
import 'contentPage.dart';
import 'package:logging/logging.dart';

var posts;
int count = 1;
final _logger = Logger('ContentList');

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
    return Container(
      margin: EdgeInsets.only(top: 20, right: 0, left: 0),
      child: ListView.separated(
          separatorBuilder: getSeparator,
          controller: _scrollController,
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            var post = posts[index];
            var image = Image.network(
              post.image,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Stack(
                    children: [
                      Center(child: Text("Carregando...",style: TextStyle(color: Colors.black54))),
                      Container(
                        color: Colors.black12,
                        height: 200,
                      )
                    ],
                  );
                }
              },
              fit: BoxFit.fill,
            );
            return ListTile(
              onTap: () {
                Navigator.of(context).push(_createRoute(post));
              },
              title: getTile(post, image, context),
              // trailing: const Icon(Icons.keyboard_arrow_right),
            );
          }),
    );
  }

  Widget getSeparator(context, index) => Divider(
        thickness: 3,
        color: Colors.black12,
      );

  getPosts() async {
    var json = await rootBundle.loadString('assets/ricmais_posts.json');
    var jsonArray = List.from(jsonDecode(json));
    try {
      jsonArray.forEach((_item) {
        Post post = Post.fromJson(_item);
        setState(() {
          posts.add(post);
          posts.toSet().toList();
        });
      });
    } catch (err) {
      _logger.info(err);
    }

    // this.page = page + 1;
    // String url = "https://ricmais.com.br/wp-json/wp/v2/posts?per_page=5&page=" +
    //     page.toString() +
    //     "&_embed&tags_exclude=222683";

    // var response = await get(Uri.parse(url));
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
          getTitle(post.category),
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
      Container(
        margin: EdgeInsets.only(top: 10),
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
            text: "${post.title}. ",
            style:
                DefaultTextStyle.of(context).style.apply(fontWeightDelta: 10),
          ),
          TextSpan(
            text: getDescription(post.excerpt),
            style: DefaultTextStyle.of(context).style,
          ),
          TextSpan(
            text: " Ver mais.",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )
        ])),
      ),
    ]);
  }

  List<Widget> getImageList(Post post, Image image) {
    var isImageValid = post.image.length > 0;

    if (isImageValid) {
      return [
        image,
        // Positioned.fill(
        //     child: Align(
        //   alignment: Alignment.bottomLeft,
        //   child: Container(
        //     margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
        //     child: Text(
        //       post.title,
        //       style: TextStyle(
        //           backgroundColor: Colors.black.withOpacity(0.3),
        //           fontSize: 20,
        //           color: Colors.white,
        //           shadows: [
        //             Shadow(
        //               blurRadius: 5.0,
        //               color: Colors.black,
        //               offset: Offset(2.0, 2.0),
        //             ),
        //           ]),
        //     ),
        //   ),
        // ))
      ];
    } else {
      return [
        Text(
          post.title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        )
      ];
    }
  }

  getDate(DateTime date) {
    var hoursPassed = new DateTime.now().difference(date);
    var year = date.year;
    var month = date.month;
    var day = date.day;
    var hour = date.hour;
    if (hoursPassed.inDays > 30) {
      var daysPassed = hoursPassed.inDays;
      var hourPassed = hoursPassed.inHours - (daysPassed * 24);

      return "Há $daysPassed dias e $hourPassed hora" +
          (hourPassed > 1 ? "s" : "");
    }
    if (hoursPassed.inDays > 30) {
      return "$day/$month/$year às $hour horas";
    }
    return "";
  }

  Route _createRoute(Post post) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MyContentPage(post: post),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  getDescription(String excerpt) {
    dom.Document document = parse(excerpt);
    return document.getElementsByTagName("p").first.innerHtml;
  }

  getCategoryColorBackground(String category) {
    switch (category.toUpperCase()) {
      case "FRIO":
        return Colors.blue;
      case "ESPORTES":
        return Color.fromRGBO(3, 45, 90, 1);
      case "SEGURANCA":
        return Color.fromRGBO(158, 28, 35, 1);
      case "NOTICIAS":
        return Color.fromRGBO(158, 28, 35, 1);
      case "ESTILO":
        return Color.fromRGBO(166, 163, 163, 1);
      case "POLITICA":
        return Color.fromRGBO(110, 153, 174, 1);
      case "CLIMA E TEMPO":
        return Color.fromRGBO(34, 158, 218, 1.0);
      case "SAUDE":
        return Color.fromRGBO(74, 203, 75, 1.0);
      case "COTIDIANO":
        return Color.fromRGBO(3, 45, 90, 1);
      default :
        return Color.fromRGBO(245, 248, 248, 1.0);
    }
  }

  getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case "FRIO":
        return Color.fromRGBO(255, 255, 255, 1.0);
      case "ESPORTES":
        return Color.fromRGBO(252, 249, 249, 1.0);
      case "SEGURANCA":
        return Color.fromRGBO(250, 249, 249, 1.0);
      case "NOTICIAS":
        return Color.fromRGBO(255, 255, 255, 1.0);
      case "ESTILO":
        return Color.fromRGBO(255, 255, 255, 1.0);
      case "POLITICA":
        return Color.fromRGBO(255, 255, 255, 1.0);
      case "CLIMA E TEMPO":
        return Color.fromRGBO(255, 255, 255, 1.0);
      case "SAÚDE":
        return Color.fromRGBO(255, 255, 255, 1.0);
      case "COTIDIANO":
        return Color.fromRGBO(255, 255, 255, 1.0);
      default :
        return Color.fromRGBO(255, 255, 255, 1.0);
    }
  }

  getTitle(String category) {
    return TextSpan(
      text: category.toUpperCase(),
      style: TextStyle(
          backgroundColor: getCategoryColorBackground(category),
          fontSize: 16,
          color: getCategoryColor(category),
          fontFamily: "Roboto",
          fontWeight: FontWeight.bold),
    );
  }
}
