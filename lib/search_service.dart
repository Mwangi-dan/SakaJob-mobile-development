import 'package:flutter/material.dart';

class SearchService with ChangeNotifier {
  List<String> _searchHistory = [];

  List<String> get searchHistory => _searchHistory;

  void addSearchQuery(String query) {
    if (!_searchHistory.contains(query)) {
      _searchHistory.add(query);
      notifyListeners();
    }
  }

  void clearSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }
}
