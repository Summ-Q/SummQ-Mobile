import 'package:flutter/material.dart';
import 'package:mobile_flutter/screens/study_flashcards.dart';
import 'package:provider/provider.dart';
import '../AiLoading_Modal.dart';
import '../providers/Deck_provider.dart';
import '../server/Api.dart';
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
        onPressed: ()async {
          final deckName = _deckNameController.text.trim();
          final notes = _notesController.text.trim();

          if (deckName.isEmpty || notes.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a deck name and your notes.')),
          );
          return;
          }

          showAILoadingModal(context);

          try {
            final newDeck = await ApiService().createDeck(title: deckName);

            final generatedCards = await ApiService().generateFlashcards(
            deckId: newDeck.id,
            notes: notes
          );

            if (mounted) {
            context.read<DeckProvider>().fetchDecks();

            Navigator.pop(context);

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudyFlashcard(
            deckTitle: newDeck.title,
            flashcards: generatedCards,
              ),
            ),
            );
          }
        } catch (e) {
            if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to generate cards: $e')),
            );
          }
        }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellowCard,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text("🪄 Generate Flashcards",
          style: TextStyle(
          color: AppColors.navy,
          fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
      ),
      ),
      const SizedBox(height: 10),
      ]),
    ),
  );
}}