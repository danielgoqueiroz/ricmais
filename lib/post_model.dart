import 'package:html_unescape/html_unescape.dart';

final unescape = new HtmlUnescape();

class Post {
  final int id;
  final String date;
  final Content excerpt;
  final String link;
  final String image;
  final Content title;
  final Content content;

  Post(this.id, this.date, this.excerpt, this.link, this.image, this.title,
      this.content);

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        json['id'],
        json['date'],
        Content.fromJson(json['excerpt']) ?? Content(''),
        json['link'],
        json['_embedded']['wp:featuredmedia']?[0]['source_url'] ?? '',
        Content.fromJson(json['title']) ?? Content(''),
        Content.fromJson(json['content']) ?? Content(''));
  }
}

class Media {
  // ignore: non_constant_identifier_names
  final String source_url;

  Media(this.source_url);

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(json['source_url'] ?? '');
  }
}

class Content {
  final String rendered;

  Content(this.rendered);

  static fromJson(Map<String, dynamic> json) {
    var text = json['rendered'];
    return Content(unescape.convert(text));
  }
}
