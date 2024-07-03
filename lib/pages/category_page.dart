import 'package:flutter/material.dart';
import 'package:news_app/pages/news_detail.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CategoryPage extends StatelessWidget {
  final String name;

  CategoryPage({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: const TextStyle(
              color: Color(0xFFB12424), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Provider.of<NewsProvider>(context, listen: false)
            .showNewsByCategory(name.toLowerCase()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Consumer<NewsProvider>(
              builder: (context, newsProvider, child) {
                if (newsProvider.resCategory?.articles == null ||
                    newsProvider.resCategory!.articles!.isEmpty) {
                  return Center(child: Text("No articles available"));
                } else {
                  return ListView.builder(
                    itemCount: newsProvider.resCategory!.articles!
                        .where((article) =>
                            article.urlToImage != null &&
                            article.urlToImage!.isNotEmpty &&
                            article.title != null &&
                            article.url != null &&
                            article.title!.isNotEmpty)
                        .length,
                    itemBuilder: (context, index) {
                      var filteredArticles = newsProvider.resCategory!.articles!
                          .where((article) =>
                              article.urlToImage != null &&
                              article.urlToImage!.isNotEmpty &&
                              article.title != null &&
                              article.url != null &&
                              article.title!.isNotEmpty)
                          .toList();

                      var article = filteredArticles[index];
                      return ShowCategory(
                        image: article.urlToImage ?? '',
                        title: article.title ?? '',
                        desc: article.description ?? '',
                        publishedAt: article.publishedAt ?? '',
                        blogUrl: article.url ?? '',
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class ShowCategory extends StatelessWidget {
  final String image;
  final String title;
  final String desc;
  final String publishedAt;
  final String blogUrl; // New field for blog url

  const ShowCategory({
    Key? key,
    required this.image,
    required this.title,
    required this.desc,
    required this.publishedAt,
    required this.blogUrl, // Initialize blog url
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(publishedAt);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    return GestureDetector(
      onTap: () {
        // Navigate to news detail page with blogUrl passed as an argument
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetail(
              blogUrl: blogUrl,
              title: title,
              publishedAt: publishedAt,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image.isNotEmpty)
              Image.network(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey,
                child: const Center(child: Text('Image not available')),
              ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              formattedDate,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
