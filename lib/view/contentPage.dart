import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:ricmais/model/post.dart';
import 'package:ricmais/view/videoPlayer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';


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
      appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.lightBlue,
          centerTitle: true,
          backgroundColor:  Color.fromRGBO(3, 45, 90, 1),
          title: Text(post.category.toUpperCase())),

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
          DateFormat("dd/MM/yyyy 'às' HH:mm").format(post.date),
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
                child: Text(
                    post.title,
                    style: TextStyle(
                        // backgroundColor: Colors.black.withOpacity(0.5),
                      fontFamily: 'Ample',
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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     getText(post.excerpt),
            //     textAlign: TextAlign.left,
            //     style: TextStyle(
            //       // backgroundColor: Colors.black.withOpacity(0.5),
            //       fontSize: 16,
            //       color: Colors.white,
            //       fontWeight: FontWeight.w300,
            //       fontFamily: 'RobotoMono',
            //       fontStyle: FontStyle.italic,
            //     ),
            //   ),
            // )
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
        getCoteElement(element, widgets);
        getReadMoreElement(element, widgets);
      }
    });
    return widgets;
  }

  void getVideoElement(dom.Element element, List<Widget> widgets) async {
    if (element.localName == 'div') {
      var nameClass = element.attributes['class'];
      if (nameClass == 'youtube-responsive-container') {
        var videoSource = element.getElementsByTagName('iframe').elementAt(0).attributes['src'].toString().split('embed/')[1];

        YoutubePlayerController _controller = YoutubePlayerController(
          initialVideoId: videoSource,
          params: YoutubePlayerParams(
            playlist: [videoSource], // Defining custom playlist
            startAt: Duration(seconds: 30),
            showControls: true,
            showFullscreenButton: true,
          ),
        );

        widgets.add(YoutubePlayerIFrame(
          controller: _controller,
          aspectRatio: 16 / 9,
        ));
      }
      widgets.add(new Text('teste'));
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

  String getText(String excerpt) {
    dom.Document document = parse(excerpt);
    return document.getElementsByTagName("p").first.innerHtml;
  }

  void getCoteElement(dom.Element element, List<Widget> widgets) {
    if (element.localName == 'blockquote') {
      widgets.add(Padding(
        padding: const EdgeInsets.all(25.0),
        child: Text(element.text,
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic
            )),
      ));
    }
  }

  void getReadMoreElement(dom.Element element, List<Widget> widgets) {
    if (element.localName == 'ul') {
      widgets.add(Padding(
        padding: const EdgeInsets.all(25.0),
        child: Text(element.text,
            style: TextStyle(
                fontSize: 16,
              fontWeight: FontWeight.bold

            )),
      ));
    }
  }

}
