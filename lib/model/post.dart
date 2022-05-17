import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';


final unescape = new HtmlUnescape();
final _logger = Logger('Post');


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

    var post = Post(0, DateTime.now(), "", "", "", "", "", "");
    try {
      var id = json['id'];
      var excerpt = json['excerpt']?['rendered'];
      var link = json['link'];
      var image = json['_embedded']['wp:featuredmedia']?[0]['source_url'] ?? '';
      var title = json['title']?['rendered'];
      var content = json['content']?['rendered'];
      var linkPage = json['link'].replaceAll("https://ricmais.com.br/", "").split('/')[0];
      post = Post(
          id,
          date,
          excerpt,
          link,
          image,
          title,
          content,
          linkPage);
    } catch (err) {
      _logger.info(err);
    }
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
