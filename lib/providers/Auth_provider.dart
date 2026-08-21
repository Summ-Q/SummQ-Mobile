import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../server/Api.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  final ApiService _apiService = ApiService();

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> login(String email, String password) async {
    _currentUser = await _apiService.login(email: email, password: password);
    notifyListeners();
  }

  Future<void> register(String name, String email, String password, String confirmPassword) async {
    _currentUser = await _apiService.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
    );
    notifyListeners();
  }

  Future<void> logout() async {
    try{
      await _apiService.logout();
      _currentUser = null;
      notifyListeners();
    }catch (e){
      throw Exception("Could not delete account: $e");
    }
  }
}