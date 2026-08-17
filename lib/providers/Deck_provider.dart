import 'package:flutter/material.dart';
import '../models/decks_model.dart';
import '../server/Api.dart';

class DeckProvider extends ChangeNotifier {
  List<DeckModel> _decks = [];
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  List<DeckModel> get decks => _decks;
  bool get isLoading => _isLoading;

  Future<void> fetchDecks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _decks = await _apiService.getDecks();
    } catch (e) {
      _decks = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void addDeck(DeckModel newDeck) {
    _decks.add(newDeck);
    notifyListeners();
  }
}