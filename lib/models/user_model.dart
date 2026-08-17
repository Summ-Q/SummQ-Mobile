class UserModel {
  final int user_id;
  final String name;
  final String email;

  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  UserModel({
    required this.name,
    required this.email, required this.user_id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      user_id: _parseId(json['id'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': user_id,
    'email': email,
  };
}
