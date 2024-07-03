import 'package:flutter/material.dart';
import 'package:news_app/components/news_card.dart';
import 'package:news_app/pages/news_detail.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (BuildContext context, news, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Find News'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: 'Write Text here ...',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          news.searchNews(searchController.text);
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  news.isDataEmpty
                      ? const SizedBox()
                      : news.isLoadingSearch
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              children: [
                                ...news.resSearch!.articles!
                                    .where((e) =>
                                        e.urlToImage != null &&
                                        e.url != null &&
                                        e.description != null &&
                                        e.description!.isNotEmpty)
                                    .map(
                                      (e) => GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NewsDetail(
                                                blogUrl: e.url!,
                                                title: e.title!,
                                                publishedAt: e.publishedAt!,
                                              ),
                                            ),
                                          );
                                        },
                                        child: NewsCard(
                                          title: e.title ?? '',
                                          image: e.urlToImage!,
                                          description: e.description!,
                                          publishedAt: e.publishedAt!,
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
