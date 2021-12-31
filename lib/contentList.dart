import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ndmais/post_model.dart';
import 'contentPage.dart';

class ContentList extends StatelessWidget {
  ContentList();

  @override
  Widget build(BuildContext context) {
    Future<String> getPosts() async {
      String url =
          "https://ndmais.com.br/wp-json/wp/v2/posts?per_page=20&page=1&_embed&tags_exclude=222683";
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Falha ao carregar posts');
      }
    }

    return Container(
      child: Container(
        child: FutureBuilder(
          future: getPosts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.separated(
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

                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyContentPage(post: post)));
                    },
                    title: Column(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          post.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.blue,
                            fontFamily: "Roboto"
                          ),
                        ),
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
                            text: getDate(post.date) + " - ",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                                color: Colors.black,
                                ),
                        ),
                        TextSpan(
                          text: post.excerpt.rendered,
                          style: DefaultTextStyle.of(context).style,
                        ),
                      ])),
                    ]),
                    // trailing: const Icon(Icons.keyboard_arrow_right),
                  );
                });
          },
        ),
      ),
    );
  }

  getDate(String dateText) {
    if (dateText == null || dateText.length == 0) {
      return "";
    }
    var formatInput = new DateFormat("yyyy-MM-dd'T'HH:mm:ss", "pt_BR");
    var formatOutput = new DateFormat.yMMMMEEEEd("pt_BR");

    var date = formatInput.parse(dateText);
    var dateTextOutput = formatOutput.format(date);
    return dateTextOutput;
  }
}
