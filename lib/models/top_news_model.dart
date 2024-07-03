// Model untuk respons API
class TopNewsModel {
  final String? status;
  final int? totalResults;
  final List<Article>? articles;

  TopNewsModel({this.status, this.totalResults, this.articles});

  // Membuat instance TopNewsModel dari JSON
  factory TopNewsModel.fromJson(Map<String, dynamic> json) {
    return TopNewsModel(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: json['articles'] != null
          ? List<Article>.from(json['articles'].map((v) => Article.fromJson(v)))
          : null,
    );
  }

  // Mengonversi TopNewsModel ke JSON
  Map<String, dynamic> toJson() => {
        'status': status,
        'totalResults': totalResults,
        'articles': articles?.map((v) => v.toJson()).toList(),
      };
}

class Article {
  final Source? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: json['source'] != null ? Source.fromJson(json['source']) : null,
        author: json['author'],
        title: json['title'],
        description: json['description'],
        url: json['url'],
        urlToImage: json['urlToImage'],
        publishedAt: json['publishedAt'],
        content: json['content'],
      );

  Map<String, dynamic> toJson() => {
        'source': source?.toJson(),
        'author': author,
        'title': title,
        'description': description,
        'url': url,
        'urlToImage': urlToImage,
        'publishedAt': publishedAt,
        'content': content,
      };
}

class Source {
  final String? id;
  final String? name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}