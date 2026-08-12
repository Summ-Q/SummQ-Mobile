class DeckModel{
  final int id;
  final int user_id;
  final String title;
  final DateTime created_at;

  DeckModel({
    required this.id,
    required this.user_id,
    required this.title,
    required this.created_at});
  factory DeckModel.fromJson(Map<String,dynamic>json){
    return DeckModel(
        id: json[''],
        user_id: json[''],
        title: json[''],
        created_at: DateTime.parse(json['created_at']));
  }

}