import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../models/decks_model.dart';
import '../models/flashcard_model.dart';

class ApiService {
  static const String baseUrl = 'https://summ-q-laraval-api.vercel.app/my-api';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // 1. AUTHENTICATION ENDPOINTS

  /// POST /api/register
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final headers = await _getHeaders(requiresAuth: false);
    final response = await http.post(Uri.parse('$baseUrl/register'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      final data = decoded['data'] ?? decoded;

      final token = data['token'];
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
      }
      return UserModel.fromJson(data['user'] ?? data);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Registration failed');
    }
  }

  /// POST /api/login
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final headers = await _getHeaders(requiresAuth: false);
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      final data = decoded['data'] ?? decoded;

      final token = data['token'];
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
      }
      return UserModel.fromJson(data['user'] ?? data);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Registration failed');
    }
  }

  /// POST /api/logout
  Future<void> logout() async {
    final headers = await _getHeaders(requiresAuth: true);
    try {
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: headers,
      );
    } catch (_) {
      // Continue clearing local token even if network fails
    } finally {
      await _storage.delete(key: 'auth_token');
    }
  }

  // 2. DECKS ENDPOINTS

  /// GET /api/decks
  Future<List<DeckModel>> getDecks() async {
    final headers = await _getHeaders(requiresAuth: true);
    final response = await http.get(
      Uri.parse('$baseUrl/decks'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      final List<dynamic> list = decoded is List ? decoded : (decoded['data'] ?? []);
      return list.map((json) => DeckModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch decks');
    }
  }

  /// POST /api/decks
  Future<DeckModel> createDeck({required String title}) async {
    final headers = await _getHeaders(requiresAuth: true);
    final response = await http.post(
      Uri.parse('$baseUrl/decks'),
      headers: headers,
      body: jsonEncode({
        'title': title,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return DeckModel.fromJson(data['deck'] ?? data['data'] ?? data);
    } else {
      throw Exception('Failed to create deck');
    }
  }

  /// DELETE /api/decks/{deck_id}
  Future<bool> deleteDeck(int deckId) async {
    final headers = await _getHeaders(requiresAuth: true);
    final response = await http.delete(
      Uri.parse('$baseUrl/decks/$deckId'),
      headers: headers,
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }

  // 3. FLASHCARDS & AI ENDPOINTS

  /// POST /api/decks/{deck_id}/generate
  /// Generates flashcards via Python GenAI from text notes
  Future<List<FlashcardModel>> generateFlashcards({
    required int deckId,
    required String notes,
  }) async {
    final headers = await _getHeaders(requiresAuth: true);
    final response = await http.post(
      Uri.parse('$baseUrl/decks/$deckId/generate'),
      headers: headers,
      body: jsonEncode({
        'notes': notes,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final dynamic decoded = jsonDecode(response.body);
      final List<dynamic> list = decoded is List ? decoded : (decoded['cards'] ?? decoded['data'] ?? []);
      return list.map((json) => FlashcardModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to generate flashcards from notes');
    }
  }

  /// GET /api/decks/{deck_id}/cards
  /// Retrieves all flashcards inside a deck
  Future<List<FlashcardModel>> getCardsForDeck(int deckId) async {
    final headers = await _getHeaders(requiresAuth: true);
    final response = await http.get(Uri.parse('$baseUrl/decks/$deckId/cards'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      List<dynamic> list = [];

      if (decoded is List) {
        list = decoded;
      } else if (decoded is Map<String, dynamic>) {
        final data = decoded['data'];
        if (data is List) {
          list = data;
        } else if (data is Map<String, dynamic>) {
          list = (data['cards'] ?? data['data'] ?? []) as List<dynamic>;
        } else {
          list = (decoded['cards'] ?? []) as List<dynamic>;
        }
      }

      return list.map((json) => FlashcardModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch cards for deck $deckId');
    }
  }

  // 3. STUDY & REVIEW ENDPOINTS

  /// GET /api/decks/{deck_id}/study
  /// Retrieves flashcards specifically queued for studying
  Future<List<FlashcardModel>> studyDeck(int deckId) async {
    final headers = await _getHeaders(requiresAuth: true);
    final response = await http.get(
      Uri.parse('$baseUrl/decks/$deckId/study'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      final List<dynamic> list = decoded is List ? decoded : (decoded['data'] ?? decoded['cards'] ?? []);
      return list.map((json) => FlashcardModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch cards for study session');
    }
  }

  /// POST /api/reviews/{flashcard_id}
  /// Submits the user's performance (Easy, Immediate, Hard) for a specific card
  Future<void> reviewFlashcard({
    required int flashcardId,
    required int difficulty,
  }) async {
    final headers = await _getHeaders(requiresAuth: true);
    final response = await http.post(
      Uri.parse('$baseUrl/reviews/$flashcardId'),
      headers: headers,
      body: jsonEncode({
        'difficulty': difficulty, // sending 1='easy', 2='immediate', or 3='hard'
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to submit review');
    }
  }

  // 4. DATA SCIENCE & AI ENDPOINTS

  /// POST /ds/predict-retention
  /// Fetches the retention prediction from the Python DS model
  Future<double> predictRetention(int deckId) async {
    final headers = await _getHeaders(requiresAuth: true);
    final response = await http.post(
      Uri.parse('$baseUrl/ds/predict-retention'),
      headers: headers,
      body: jsonEncode({'deck_id': deckId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['retention_score'] ?? 0.0).toDouble();
    } else {
      throw Exception('Failed to get retention prediction');
    }
  }
}