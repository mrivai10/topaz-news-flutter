import 'package:flutter/material.dart';
import 'package:news_app/helper/api.dart';
import 'package:news_app/models/top_news_model.dart';
import 'package:news_app/utils/news_api.dart';

class NewsProvider with ChangeNotifier {
  bool isDataEmpty = true;
  bool isLoading = true;
  bool isLoadingSearch = true;
  TopNewsModel? resNews;
  TopNewsModel? resSearch;
  TopNewsModel? resBNews;
  TopNewsModel? resCategory;

  setLoading(data) {
    isLoading = data;
    notifyListeners();
  }

  getTopNews() async {
    final res = await api(
        '${baseURL}top-headlines?country=us&category=technology&apiKey=$apiKey');

    if (res.statusCode == 200) {
      resNews = TopNewsModel.fromJson(res.data);
    } else {
      resNews = TopNewsModel();
    }
    isLoading = false;
    notifyListeners();
  }

  searchNews(String search) async {
    isDataEmpty = false;
    isLoadingSearch = true;
    notifyListeners();

    final res = await api(
        '${baseURL}everything?q=$search&sortBy=popularity&apiKey=$apiKey');

    if (res.statusCode == 200) {
      resSearch = TopNewsModel.fromJson(res.data);
    } else {
      resSearch = TopNewsModel();
    }
    isLoadingSearch = false;
    notifyListeners();
  }

  getBreakingNews() async {
    final res = await api(
        '${baseURL}top-headlines?country=us&sortBy=popularity&apiKey=$apiKey');

    if (res.statusCode == 200) {
      resBNews = TopNewsModel.fromJson(res.data);
    } else {
      resBNews = TopNewsModel();
    }
    isLoading = false;
    notifyListeners();
  }

  showNewsByCategory(String category) async {
    final res = await api(
        '${baseURL}top-headlines?country=us&category=$category&apiKey=$apiKey');

    if (res.statusCode == 200) {
      resCategory = TopNewsModel.fromJson(res.data);
    } else {
      resCategory = TopNewsModel();
    }
    isLoading = false;
    notifyListeners();
  }
}
