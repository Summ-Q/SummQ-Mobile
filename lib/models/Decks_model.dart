class DeckModel {
  final int id;
  final String title;
  final DateTime createdAt;

  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  DeckModel({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      id: _parseId(json['id'] ?? ''),
      title: json['name'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': title,
    'created_at': createdAt.toIso8601String(),
  };
}