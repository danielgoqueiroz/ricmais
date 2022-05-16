import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

final unescape = new HtmlUnescape();

class Post {
  final int id;
  final DateTime date;
  final String excerpt;
  final String link;
  final String image;
  final String title;
  final String content;
  final String category;

  Post(this.id, this.date, this.excerpt, this.link, this.image, this.title,
      this.content, this.category);

  factory Post.fromJson(Map<String, dynamic> json) {
    var dateText = json['date'];
    var formatInput = new DateFormat("yyyy-MM-dd'T'HH:mm:ss", "pt_BR");
    var date = new DateTime.fromMicrosecondsSinceEpoch(
        formatInput.parse(dateText).microsecondsSinceEpoch);

    var post = Post(
        json['id'],
        date,
        json['excerpt']?['rendered'],
        json['link'],
        json['_embedded']['wp:featuredmedia']?[0]['source_url'] ?? '',
        json['title']?['rendered'],
        json['content']?['rendered'],
        json['link'].replaceAll("https://ricmais.com.br/", "").split('/')[0]);
    return post;
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
