import 'package:flutter/material.dart';
import 'package:mobile_flutter/screens/study_flashcards.dart';

import '../AiLoading_Modal.dart';
import '../models/flashcard_model.dart';
import '../theme.dart';

class PasteScreen extends StatefulWidget {
  const PasteScreen({Key? key}) : super(key: key);

  @override
  State<PasteScreen> createState() => _PasteNotesScreenState();
}

class _PasteNotesScreenState extends State<PasteScreen> {
  final TextEditingController _deckNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _deckNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create New Deck",
          style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold
        ),
      ),
      centerTitle: true,
    ),

      body: Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      const Text("Deck Name",
        style: TextStyle(
        color: AppColors.orangCream,
        fontSize: 18,
        ),
      ),
      const SizedBox(height: 12),

      TextField(
      controller: _deckNameController,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor:AppColors.greyCard,
        hintText: "...",
        hintStyle: TextStyle(color: AppColors.cream),
        border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
        ),
      ),

      const SizedBox(height: 32),

      const Text(
      "Paste your notes here",
      style: TextStyle(
        color: AppColors.orangCream,
        fontSize: 18,
      ),
      ),
      const SizedBox(height: 12),

      Expanded(
      child: TextField(
      controller: _notesController,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      style: const TextStyle(
        color: Colors.white,
        height: 1.4,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.greyCard,
        hintText: "...",
        hintStyle: TextStyle(color: AppColors.cream),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
          ),
        contentPadding: const EdgeInsets.all(20),
        ),
      ),
      ),

      const SizedBox(height: 24),

      SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          final deckName = _deckNameController.text.trim().isEmpty
              ? 'Untitled Deck'
              : _deckNameController.text.trim();
          final notes = _notesController.text.trim();

          if (notes.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Paste some notes first')),
            );
            return;
          }

          showAILoadingModal(context);

          // TODO: replace with real API call once backend is ready
          final cards = await _mockGenerateFlashcards(deckName, notes);

          if (!context.mounted) return;
          Navigator.pop(context); // dismiss loading modal

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudyFlashcard(deckTitle: deckName, flashcards: [],),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.yellowCard,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        ),
        ),
        child: const Text(
        "🪄 Generate Flashcards",
        style: TextStyle(
          color: AppColors.navy,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ),
      const SizedBox(height: 10),
      ],
      ),
      ),
      );
    }
  }

Future<List<FlashcardModel>> _mockGenerateFlashcards(String deckName, String notes) async {
  await Future.delayed(const Duration(seconds: 2)); // simulate network
  return List.generate(5, (i) => FlashcardModel(
    id: i,
    deckId: 0,
    question: 'Sample question ${i + 1} from "$deckName"',
    answer: 'Sample answer ${i + 1}',
    difficultyLevel: 'medium',
  ));
}