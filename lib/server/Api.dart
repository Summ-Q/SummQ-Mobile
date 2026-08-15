import 'package:dio/dio.dart';
import '../models/flashcard_model.dart';

class Helper{
  final dio = Dio();

  Future<FlashcardModel> getData(String userName) async {
    final response = await dio.get('https://opentdb.com/api.php?amount=10&category=18');
    FlashcardModel flashCard = FlashcardModel.fromJson(response.data);
    return flashCard;

  }
}
