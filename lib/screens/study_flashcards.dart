import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:mobile_flutter/screens/session_complete.dart';
import 'package:mobile_flutter/theme.dart';
import 'package:flip_card/flip_card.dart';

import '../widgets/repeted_button.dart';

class StudyFlashcard extends StatefulWidget {
  const StudyFlashcard({Key? key}) : super(key: key);

  @override
  State<StudyFlashcard> createState() => _StudyFlashcardState();
}

class _StudyFlashcardState extends State<StudyFlashcard> {
  bool isPressed = false;
  int currentIndex = 0;
  int totalQuestions = 10;
  FlipCardController _controller = FlipCardController();

  @override
  Widget build(BuildContext context) {
    double progressValue = (currentIndex + 1) / totalQuestions;
    return Scaffold(
      backgroundColor: AppColors.navy,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Logic",
          style: TextStyle(
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
                "Card 18 of 30",
                style: TextStyle(
                  color: AppColors.orangCream,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 10,),
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
                          child: Text("All cats are mammals. No mammals are reptiles.\n\nBased on this information, which of the following statements must be true?",
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
                          backgroundColor: AppColors.creamText,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
                          _controller.toggleCard();
                          isPressed = true;
                        },
                        child: const Text('Show answer'),
                      )
                    ],
                  ),),
                back: Container(
                  decoration: BoxDecoration(
                    color: AppColors.chartGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Answer will Appear here', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 24),
            if (isPressed)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildRepetitionButton("Easy", AppColors.chartGreen),
                  buildRepetitionButton("Immediate", AppColors.yellowCard),
                  buildRepetitionButton("Hard", AppColors.chartRed),
                ],
              ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text("Back", style: TextStyle(color: AppColors.greyCard, fontSize: 16)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (currentIndex < totalQuestions - 1) {
                        currentIndex++;
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SessionComplete(totalQuestions: totalQuestions,)),
                        );
                      }
                    });
                  },
                  child: const Text("Next", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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