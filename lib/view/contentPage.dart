import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:ndmais/model/post.dart';
import 'package:ndmais/view/videoPlayer.dart';

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
    dom.Document document = parse(post.content);

    List<Widget> widgets = [];

    Widget image = mainImageWidget();
    widgets.add(image);

    titleWidgets(widgets);

    widgets.addAll(getContentWidgets(document));
    // widgets.add(mainImageWidget());

    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Container(
          child: SingleChildScrollView(
        child: Column(children: widgets),
      )),
    );
  }

  void titleWidgets(List<Widget> widgets) {

    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          post.date.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontFamily: 'Roboto'),
        ),
      ),
    ));
  }

  Widget mainImageWidget() {
    var isImageValid = post.image.length > 0;
    Widget image = Stack(
      children: [
        Container(
          child: isImageValid
              ? Image.network(
                  post.image,
                  fit: BoxFit.fitWidth,
                  color: const Color.fromRGBO(0, 0, 0, 90),
                  colorBlendMode: BlendMode.darken,
                )
              : null,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(post.title,
                    style: TextStyle(
                        // backgroundColor: Colors.black.withOpacity(0.5),
                        fontSize: 22,
                        color: isImageValid ? Colors.white : Colors.black,
                        shadows: [
                          isImageValid
                              ? Shadow(
                                  blurRadius: 5.0,
                                  color: Colors.black,
                                  offset: Offset(2.0, 2.0),
                                )
                              : Shadow(),
                        ])),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                post.excerpt,
                textAlign: TextAlign.left,
                style: TextStyle(
                  // backgroundColor: Colors.black.withOpacity(0.5),
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'RobotoMono',
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          ],
        )
      ],
    );
    return image;
  }

  List<Widget> getContentWidgets(dom.Document document) {
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

  void getVideoElement(dom.Element element, List<Widget> widgets) async {
    if (element.localName == 'div') {
      var nameClass = element.attributes['class'];
      if (nameClass == 'ndmais-content-video') {
        var videoSource = element.getElementsByTagName('source').elementAt(0).attributes['src'].toString();
        var videoCaption = element.getElementsByClassName('ndmais-content-video-caption').elementAt(0).text;

        widgets.add(new VideoApp(url: videoSource, caption: videoCaption));
      }

      element.getElementsByClassName('player-content').forEach((element) {
        widgets.add(
          Text('player-content'),
        );
      });
    }
  }

  void getImagesWidget(dom.Element element, List<Widget> widgets) {
    if (element.localName == 'div') {
      var classText = element.attributes['class'];
      var isGaleryElement =
          classText.toString().contains('galeria-de-fotos-slider');
      if (isGaleryElement) {
        var fotosElements = element.getElementsByTagName('img');
        var carrousel = CarouselSlider(
          options: CarouselOptions(height: 250.0),
          items: fotosElements.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(5),
                    child: Image.network(
                      i.attributes['data-src'].toString(),
                      fit: BoxFit.scaleDown,
                    ));
              },
            );
          }).toList(),
        );
        widgets.add(carrousel);
      } else {
        element.getElementsByTagName('img').forEach((imgElement) {
          var containsAtt = imgElement.attributes.containsKey('src');
          String link = containsAtt
              ? imgElement.attributes['src']!
              : imgElement.attributes['data-src']!;
          // String description = element.getElementsByTagName('span')[0].text;

          var image = Image.network(
            link,
            fit: BoxFit.fitWidth,
          );
          widgets.add(Container(
            child: Stack(children: [
              image,
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Text("imagem",
                    style: TextStyle(
                        backgroundColor: Colors.black.withOpacity(0.4),
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
            ]),
          ));
        });
      }
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
