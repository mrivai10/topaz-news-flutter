import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/news_card.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/pages/category_page.dart';
import 'package:news_app/pages/news_detail.dart';
import 'package:news_app/pages/search_page.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:news_app/services/data.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];
  int activeIndex = 0;

  getNews() async {
    await Provider.of<NewsProvider>(context, listen: false).getTopNews();
    await Provider.of<NewsProvider>(context, listen: false).getBreakingNews();
  }

  @override
  void initState() {
    categories = getCategories();
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (BuildContext context, news, Widget? child) {
        final breakingNews = news.resBNews?.articles
                ?.where((article) =>
                    article.urlToImage != null &&
                    article.urlToImage!.isNotEmpty &&
                    article.title != null &&
                    article.title!.isNotEmpty)
                .take(5)
                .toList() ??
            [];
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Text(
                  "Topaz",
                  style: TextStyle(
                      color: Color(0xFFE2E2E2), fontWeight: FontWeight.bold),
                ),
                Text(
                  "News",
                  style: TextStyle(
                      color: Color(0xFFF5D278), fontWeight: FontWeight.bold),
                )
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchPage()),
                      );
                    },
                    icon: const Icon(Icons.search)),
              ),
            ],
            backgroundColor: const Color(0xFFB12424),
          ),
          backgroundColor: const Color(0xFFE2E2E2),
          body: RefreshIndicator(
            onRefresh: () async {
              news.setLoading(true);
              await getNews();
              news.setLoading(false);
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            image: categories[index].image,
                            categoryName: categories[index].categoryName,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          "Breaking News",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BreakingNews(
                                        newsProvider: news,
                                      )),
                            );
                          },
                          child: const Text(
                            "Explore",
                            style: TextStyle(
                              color: Color(0xFFB12424),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  news.isLoading || news.resBNews == null
                      ? Center(child: CircularProgressIndicator())
                      : CarouselSlider.builder(
                          itemCount: breakingNews.length,
                          itemBuilder: (context, index, realIndex) {
                            var article = breakingNews[index];
                            return buildImage(
                                article.urlToImage!, index, article.title!);
                          },
                          options: CarouselOptions(
                            height: 220,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onPageChanged: (index, reason) => setState(() {
                              activeIndex = index;
                            }),
                          ),
                        ),
                  const SizedBox(height: 20),
                  Center(child: buildIndicator(news)),
                  const SizedBox(height: 20),
                  BlogSection(newsProvider: news),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildImage(String imageUrl, int index, String title) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                height: 220,
                imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'images/business.jpg',
                    height: 220,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  );
                },
              ),
            ),
            Container(
              height: 250,
              padding: const EdgeInsets.only(left: 15, top: 15),
              margin: const EdgeInsets.only(top: 130),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Text(
                title,
                maxLines: 2,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
  Widget buildIndicator(NewsProvider news) => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 5,
        effect: const SlideEffect(
            dotWidth: 10, dotHeight: 10, activeDotColor: Color(0xFFB12424)),
      );
}

class CategoryTile extends StatelessWidget {
  final image, categoryName;

  CategoryTile({this.image, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(name: categoryName),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                image,
                width: 120,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Color.fromARGB(135, 0, 0, 0),
              ),
              child: Center(
                child: Text(
                  categoryName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogSection extends StatelessWidget {
  final NewsProvider newsProvider;

  const BlogSection({Key? key, required this.newsProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            "Trending",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              newsProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        ...newsProvider.resNews!.articles!
                            .where((e) =>
                                e.urlToImage != null &&
                                e.description != null &&
                                e.description!.isNotEmpty &&
                                e.url != null)
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
      ],
    );
  }
}

class BreakingNews extends StatelessWidget {
  final NewsProvider newsProvider;

  const BreakingNews({Key? key, required this.newsProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Breaking News",
          style: TextStyle(
            color: Color(0xFFB12424),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: newsProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: newsProvider.resBNews!.articles!
                  .where((e) =>
                      e.urlToImage != null &&
                      e.description != null &&
                      e.description!.isNotEmpty &&
                      e.url != null)
                  .length,
              itemBuilder: (context, index) {
                final filteredArticles = newsProvider.resBNews!.articles!
                    .where((e) =>
                        e.urlToImage != null &&
                        e.description != null &&
                        e.description!.isNotEmpty &&
                        e.url != null)
                    .toList();
                final e = filteredArticles[index];
                return GestureDetector(
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
                );
              },
            ),
      ),
    );
  }
}