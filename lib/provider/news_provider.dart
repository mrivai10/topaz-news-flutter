import 'package:flutter/material.dart';
import 'package:news_app/helper/api.dart';
import 'package:news_app/models/top_news_model.dart';
import 'package:news_app/utils/news_api.dart';

// Mengelola state dan panggilan API untuk fungsionalitas berita
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

  // Mengambil berita teratas dalam kategori teknologi 
  // Memperbarui [resNews] dengan data yang diambil
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

  // Mencari berita berdasarkan query yang diberikan
  // Memperbarui [resSearch] dengan hasil pencarian
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

  // Mengambil berita terpopuler
  // Memperbarui [resBNews] dengan data yang diambil
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

  // Mengambil berita untuk kategori tertentu 
  // Memperbarui [resCategory] dengan data yang diambil
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
