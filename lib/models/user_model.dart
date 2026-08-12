class UserModel{
  final String name;
  final String password;
  final String email;

  UserModel({
    required this.name,
    required this.password,
    required this.email
  });
  factory UserModel.fromJson(Map<String,dynamic>json){
    return UserModel(
      name: json['name'],
      password: json['password'],
      email: json['email']
    );
  }
}