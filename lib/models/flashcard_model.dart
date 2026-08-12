class FlashcardModel{
  final int id;
  final int deck_id;
  final String question;
  final String answer;
  final String difficulty_level;

  FlashcardModel({
    required this.id,
    required this.deck_id,
    required this.question,
    required this.answer,
    required this.difficulty_level});
  factory FlashcardModel.fromJson(Map<String,dynamic>json){
    return FlashcardModel(
        id: json[''],
        deck_id: json[''],
        question: json[''],
        answer: json[''],
        difficulty_level: json['']);
  }
}