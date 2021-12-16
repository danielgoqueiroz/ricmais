import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:ndmais/post_model.dart';

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
    dom.Document document = parse(post.content.rendered);

    List<Widget> widgets = [];

    // Widget image = mainImageWidget();
    // widgets.add(image);

    titleWidgets(widgets);

    widgets.addAll(getContantWidgets(document));

    return Scaffold(
      appBar: AppBar(title: Text(post.title.rendered)),
      body: Container(
          child: SingleChildScrollView(
        child: Column(children: widgets),
      )),
    );
  }

  void titleWidgets(List<Widget> widgets) {
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(post.title.rendered,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        post.excerpt.rendered,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w300,
            fontFamily: 'Roboto',
            fontStyle: FontStyle.italic),
      ),
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        post.date,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w300,
            fontFamily: 'Roboto'),
      ),
    ));
  }

  Widget mainImageWidget() {
    Widget image = Stack(
      children: [
        Container(
          child: Image.network(
            post.image,
            fit: BoxFit.fitWidth,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Text(post.title.rendered,
                style: TextStyle(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    fontSize: 24,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ])),
          ),
        )
      ],
    );
    return image;
  }

  List<Widget> getContantWidgets(dom.Document document) {
    List<Widget> widgets = [];

    dom.Element body = document.getElementsByTagName('body')[0];
    body.nodes.forEach((element) {
      if (element is dom.Element) {
        getTextsWidget(element, widgets);
        getImagesWidget(element, widgets);
        getVideoElement(element, widgets);
      }
    });
    return widgets;
  }

  void getVideoElement(dom.Element element, List<Widget> widgets) {
    if (element.localName == 'div') {
      element.getElementsByClassName('ndmais-content-video').forEach((element) {
        widgets.add(
          Text('Vídeo'),
        );
      });
    }
  }

  void getImagesWidget(dom.Element element, List<Widget> widgets) {
    if (element.localName == 'div') {
      element.getElementsByTagName('img').forEach((imgElement) {
        String link = imgElement.attributes['src']!;
        String description = element.getElementsByTagName('span')[0].text;
        if (link != null) {
          widgets.add(Stack(children: [
            Image.network(
              link,
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: Text(description,
                  style: TextStyle(
                      backgroundColor: Colors.black.withOpacity(0.3),
                      fontSize: 12,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 1.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ])),
            )
          ]));
        }
      });
    }
  }

  void getTextsWidget(dom.Element element, List<Widget> widgets) {
    if (element.localName == 'p') {
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(element.text,
            style: TextStyle(
              fontSize: 16,
            )),
      ));
    }
  }
}
