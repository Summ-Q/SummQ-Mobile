class deckModel{
  final int id;
  final int user_id;
  final String title;
  final DateTime created_at;

  deckModel({
    required this.id,
    required this.user_id,
    required this.title,
    required this.created_at});
  factory deckModel.fromJson(Map<String,dynamic>json){
    return deckModel(
        id: json[''],
        user_id: json[''],
        title: json[''],
        created_at: json['']);
  }

}