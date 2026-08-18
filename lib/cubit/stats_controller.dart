import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsController extends ChangeNotifier {
  static final StatsController instance = StatsController._internal();

  StatsController._internal() {
    _loadSavedData();
  }

  bool isDeckStudied(int deckId) {
    return _studiedDeckIds.contains(deckId);
  }

  Set<int> _studiedDeckIds = {};
  int _decksCreated = 0;

  int get studiedDecksCount => _studiedDeckIds.length;
  int get decksCreated => _decksCreated;

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    _decksCreated = prefs.getInt('decks_created') ?? 0;

    final List<String>? savedIds = prefs.getStringList('studied_decks');
    if (savedIds != null) {
      _studiedDeckIds = savedIds.map((id) => int.parse(id)).toSet();
    }

    notifyListeners();
  }

  Future<void> markDeckAsStudied(int deckId) async {
    if (!_studiedDeckIds.contains(deckId)) {
      _studiedDeckIds.add(deckId);
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final List<String> stringIds = _studiedDeckIds.map((id) => id.toString()).toList();
      await prefs.setStringList('studied_decks', stringIds);
    }
  }

  Future<void> setDecksCreated(int count) async {
    _decksCreated = count;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('decks_created', count);
  }
}