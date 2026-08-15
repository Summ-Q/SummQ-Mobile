import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:mobile_flutter/models/flashcard_model.dart';
import 'package:mobile_flutter/screens/session_complete.dart';
import 'package:mobile_flutter/theme.dart';
import 'package:flip_card/flip_card.dart';
import '../widgets/repeted_button.dart';


class StudyFlashcard extends StatefulWidget {
  const StudyFlashcard({
    super.key,
    required this.deckTitle,
    required this.flashcards,
  });

  final String deckTitle;
  final List<FlashcardModel> flashcards;

  @override
  State<StudyFlashcard> createState() => _StudyFlashcardState();
}

class _StudyFlashcardState extends State<StudyFlashcard> {
  bool isPressed = false;
  int currentIndex = 0;
  final FlipCardController _controller = FlipCardController();

  FlashcardModel get currentCard => widget.flashcards[currentIndex];
  int get totalQuestions => widget.flashcards.length;

  void _goNext() {
    if (currentIndex < totalQuestions - 1) {
      setState(() {
        currentIndex++;
        isPressed = false;
       // _controller.flip();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SessionComplete(totalQuestions: totalQuestions),
        ),
      );
    }
  }

  void _goBack() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        isPressed = false;
       // _controller.flip(CardSide.front);
      });
    }
  }

  void _recordAnswer(String label) {
    // TODO: send review result (Easy/Immediate/Hard) to backend once ready
    _goNext();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flashcards.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.navy,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined, color: AppColors.cream),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            "This deck has no cards yet.",
            style: TextStyle(color: AppColors.cream, fontSize: 16),
          ),
        ),
      );
    }

    double progressValue = (currentIndex + 1) / totalQuestions;

    return Scaffold(
      backgroundColor: AppColors.navy,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.deckTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: AppColors.cream),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Card ${currentIndex + 1} of $totalQuestions",
                style: const TextStyle(
                  color: AppColors.orangCream,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progressValue,
                backgroundColor: AppColors.greyCard,
                color: AppColors.yellowLink,
                minHeight: 12,
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: FlipCard(
                key: ValueKey(currentCard.id),
                fill: Fill.fillBack,
                controller: _controller,
                flipOnTouch: false,
                direction: FlipDirection.HORIZONTAL,
                side: CardSide.FRONT,
                onFlip: () {
                  setState(() {
                    isPressed = !isPressed;
                  });
                },
                front: Container(
                  decoration: BoxDecoration(
                    color: AppColors.greyCard,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            currentCard.question,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.yellowLink,
                          backgroundColor: AppColors.navy,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
                          _controller.toggleCard();
                          setState(() => isPressed = true);
                        },
                        child: const Text('Show answer'),
                      )
                    ],
                  ),
                ),
                back: Container(
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    currentCard.answer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (isPressed)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => _recordAnswer('Easy'),
                    child: buildRepetitionButton("Easy", AppColors.green),
                  ),
                  GestureDetector(
                    onTap: () => _recordAnswer('Immediate'),
                    child: buildRepetitionButton("Immediate", AppColors.yellowCard),
                  ),
                  GestureDetector(
                    onTap: () => _recordAnswer('Hard'),
                    child: buildRepetitionButton("Hard", AppColors.chartRed),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: currentIndex > 0 ? _goBack : null,
                  child: Text(
                    "Back",
                    style: TextStyle(
                      color: currentIndex > 0 ? Colors.white : AppColors.greyCard,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _goNext,
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}