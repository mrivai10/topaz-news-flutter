import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetail extends StatefulWidget {
  final String blogUrl;
  final String title;

  const NewsDetail(
      {Key? key,
      required this.blogUrl,
      required this.title,
      required String publishedAt})
      : super(key: key);

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Color(0xFFB12424),
        ),
        body: Container(
          child: WebView(
            initialUrl: widget.blogUrl,
            gestureNavigationEnabled: true,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ));
  }
}
