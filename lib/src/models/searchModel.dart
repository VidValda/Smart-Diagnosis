import 'package:flutter/cupertino.dart';
import 'package:google_sign_in_test/src/models/search_result.dart';

class SearchModel with ChangeNotifier {
  List<SearchResult> _historial = [];

  List<SearchResult> get historial => this._historial;

  addHistorial(SearchResult searchResult) {
    _historial.add(searchResult);
  }

  deleteHistorial(SearchResult searchResult) {
    final newList = _historial
        .where((result) => result.nombreDest != searchResult.nombreDest)
        .toList();
    _historial = newList;
  }
}
