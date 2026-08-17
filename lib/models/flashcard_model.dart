class FlashcardModel {
  final int card_id;
  final int deckId;
  final String question;
  final String answer;
  final String difficultyLevel;
  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  FlashcardModel({
    required this.card_id,
    required this.deckId,
    required this.question,
    required this.answer,
    required this.difficultyLevel,
  });

  factory FlashcardModel.fromJson(Map<String, dynamic> json, {int deckId = 0}) {
    return FlashcardModel(
      card_id: _parseId(json['id'] ?? ''),
      deckId: deckId,
      question: json['question'] ?? '',
      answer: json['correct_answer'] ?? json['answer'] ?? '',
      difficultyLevel: json['difficulty'] ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': card_id,
    'deck_id': deckId,
    'question': question,
    'answer': answer,
    'difficulty_level': difficultyLevel,
  };
}