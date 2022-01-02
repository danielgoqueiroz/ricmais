import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ndmais/post_model.dart';
import 'contentPage.dart';

var posts;
int count = 1;

class ContentList extends StatefulWidget {
  ContentList();

  @override
  State createState() => new DynamicList();
}

Future<String> getPosts(int page) async {
  String url =
      "https://ndmais.com.br/wp-json/wp/v2/posts?per_page=5&page=" +
          page.toString() +
          "&_embed&tags_exclude=222683";
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var items = response.body;
    
    return items;
  } else {
    throw Exception('Falha ao carregar posts');
  }
}

class DynamicList extends State<ContentList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: FutureBuilder(
          future: getPosts(count),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.separated(
                addAutomaticKeepAlives: false,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.blue,
                    ),
                itemCount: snapshot.data == null
                    ? 0
                    : jsonDecode(snapshot.data).length,
                itemBuilder: (BuildContext context, int index) {
                  var jsonArray = jsonDecode(snapshot.data);
                  var jsonObject = jsonArray[index];
                  Post post = Post.fromJson(jsonObject);
                  var image = Image.network(
                    post.image,
                    fit: BoxFit.fill,
                  );

                  if (index + 1 == jsonDecode(snapshot.data).length) {
                    return ListTile(
                      onTap: () {},
                      title: Container(
                          color: Colors.lightBlue,
                          child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  count += 1;
                                  getPosts(count);
                                });
                              },
                              child: Text("Carregar mais",
                                  style: TextStyle(color: Colors.white)))),
                    );
                  } else {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyContentPage(post: post)));
                      },
                      title: Column(children: [
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
                          children: [
                            post.image.length > 0 ? image : Text("Sem imagem"),
                            Positioned.fill(
                                child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                margin: EdgeInsets.all(8),
                                child: Text(
                                  post.title.rendered,
                                  style: TextStyle(
                                      backgroundColor:
                                          Colors.black.withOpacity(0.3),
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
                          ],
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: post.excerpt.rendered,
                            style: DefaultTextStyle.of(context).style,
                          ),
                          TextSpan(
                            text: " Ver mais.",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ])),
                      ]),
                      // trailing: const Icon(Icons.keyboard_arrow_right),
                    );
                  }
                });
          },
        ),
      ),
    );
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
