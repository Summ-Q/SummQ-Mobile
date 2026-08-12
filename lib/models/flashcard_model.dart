class flashcardModel{
  final int id;
  final int deck_id;
  final String question;
  final String answer;
  final String difficulty_level;

  flashcardModel({
    required this.id,
    required this.deck_id,
    required this.question,
    required this.answer,
    required this.difficulty_level});
  factory flashcardModel.fromJson(Map<String,dynamic>json){
    return flashcardModel(
        id: json[''],
        deck_id: json[''],
        question: json[''],
        answer: json[''],
        difficulty_level: json['']);
  }
}