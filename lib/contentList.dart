import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
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
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data == null
                    ? 0
                    : jsonDecode(snapshot.data).length,
                itemBuilder: (BuildContext context, int index) {
                  var jsonArray = jsonDecode(snapshot.data);
                  var jsonObject = jsonArray[index];

                  Post post = Post.fromJson(jsonObject);
                  var image = Image.network(
                    post.image,
                    fit: BoxFit.cover,
                  );

                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyContentPage(post: post)));
                    },
                    trailing: const Icon(Icons.arrow_forward_ios),

                    leading: Container(
                          margin: EdgeInsetsGeometry.lerp(EdgeInsets.zero, EdgeInsets.zero, 10),
                          width: 100,
                          height: 500,
                          child: image,
                    ),
                    title: Text(post.title.rendered),
                    subtitle: Text(post.excerpt.rendered),
                  );
                });
          },
        ),
      ),
    );
  }
}
