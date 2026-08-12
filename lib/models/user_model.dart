class userModel{
  final String name;
  final String password;
  final String email;

  userModel({
    required this.name,
    required this.password,
    required this.email
  });
  factory userModel.fromJson(Map<String,dynamic>json){
    return userModel(
      name: json['name'],
      password: json['password'],
      email: json['email']
    );
  }
}