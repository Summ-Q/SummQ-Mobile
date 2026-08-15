import 'package:flutter/foundation.dart';

class StatsController extends ChangeNotifier {
  StatsController._internal();
  static final StatsController instance = StatsController._internal();

  int _studiedCards = 0;
  int _decksCreated = 0;

  int get studiedCards => _studiedCards;
  int get decksCreated => _decksCreated;

  void addStudiedCards(int count) {
    _studiedCards += count;
    notifyListeners();
  }

  void incrementDecksCreated() {
    _decksCreated++;
    notifyListeners();
  }

  void setDecksCreated(int count) {
    _decksCreated = count;
    notifyListeners();
  }
}