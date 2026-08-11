import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class sessionComplete extends StatelessWidget {
  final int totalQuestions;

  const sessionComplete({super.key, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network('https://lottie.host/45b7b74c-72bf-4e5f-9250-95adf7f695c7/Ilp1M1ZZrY.json',
              width: 300,
              height: 300,
              repeat: true,
            ),

            const Text(
              "Quiz Completed!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),

            const SizedBox(height: 20),

            Text(
              "Your Score :",
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
            ),


            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Home", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}