class FlashcardModel {
  final int id;
  final int deckId;
  final String question;
  final String answer;
  final String difficultyLevel;

  FlashcardModel({
    required this.id,
    required this.deckId,
    required this.question,
    required this.answer,
    required this.difficultyLevel,
  });

  factory FlashcardModel.fromJson(Map<String, dynamic> json, {int deckId = 0}) {
    return FlashcardModel(
      id: json['id'] ?? 0,
      deckId: deckId,
      question: json['question'] ?? '',
      answer: json['correct_answer'] ?? json['answer'] ?? '',
      difficultyLevel: json['difficulty'] ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'deck_id': deckId,
    'question': question,
    'answer': answer,
    'difficulty_level': difficultyLevel,
  };
}