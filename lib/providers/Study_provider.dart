import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../server/Api.dart';

class StudyProvider extends ChangeNotifier {
  List<FlashcardModel> _cards = [];
  int _currentIndex = 0;
  bool _isAnswerRevealed = false;
  final ApiService _apiService = ApiService();

  int get currentIndex => _currentIndex;
  int get totalQuestions => _cards.length;
  bool get isAnswerRevealed => _isAnswerRevealed;
  double get progress => _cards.isEmpty ? 0 : (_currentIndex + 1) / _cards.length;
  FlashcardModel? get currentCard => _cards.isEmpty ? null : _cards[_currentIndex];

  void loadCards(List<FlashcardModel> deckCards) {
    _cards = deckCards;
    _currentIndex = 0;
    _isAnswerRevealed = false;
    notifyListeners();
  }

  void revealAnswer() {
    _isAnswerRevealed = true;
    notifyListeners();
  }

  /// Submits the answer to the backend and advances the deck.
  /// Returns `true` if the session is complete.
  Future<bool> submitAnswer(int difficultyLevel) async {
    final current = currentCard;

    if (current != null) {
      try {
        await _apiService.reviewFlashcard(
          flashcardId: current.card_id,
          difficulty: difficultyLevel,
        );
      } catch (e) {
        debugPrint('Error submitting review: $e');
        // You can handle offline caching here in the future
      }
    }

    if (_currentIndex < _cards.length - 1) {
      _currentIndex++;
      _isAnswerRevealed = false;
      notifyListeners();
      return false; // Session continues
    } else {
      return true; // Session complete
    }
  }
}