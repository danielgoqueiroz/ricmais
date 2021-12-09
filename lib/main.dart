import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndmais/post_model.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ndmais',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ND+'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String json = "";

  Future<String> getPosts() async {
    String url =
        "https://ndmais.com.br/wp-json/wp/v2/posts?per_page=10&page=1&_embed&tags_exclude=222683";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Falha ao carregar posts');
    }
  }

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
      body: Container(
        child: Container(
          child: FutureBuilder(
            future: getPosts(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data == null ? 0 : jsonDecode(snapshot.data).length,
                  itemBuilder: (BuildContext context, int index) {
                    Post post = Post.fromJson(jsonDecode(snapshot.data)[index]);
                    return ListTile(
                      onTap: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => (Content())));
                      },
                      leading: Container(
                          width: 80,
                          height: 80,
                          child: Image.network(
                            post.image,
                            fit: BoxFit.fitHeight,
                            height: 200,
                            width: 200,
                          )
                      ),
                      title: Text(post.title.rendered),
                      subtitle: Text(post.excerpt.rendered),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('context')
      ),
      body: Text('content'),
    );
  }

}
