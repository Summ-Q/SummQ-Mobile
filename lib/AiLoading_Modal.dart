import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_flutter/theme.dart';

Future<void> showAILoadingModal(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false, // to Prevent user from tapping outside to close it
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.network('https://lottie.host/09288781-7f84-43fd-a3e4-5a2a3fa4e7af/sJlMHXi1VZ.json',
                width: double.infinity,
                height: 150,
                repeat: true,
              ),
              const SizedBox(height: 24),

              const Text(
                "Ai is Reading your lecture...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                "This might take a few seconds",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 32),

              const CircularProgressIndicator(
                color: AppColors.navy,
              ),
            ],
          ),
        ),
      );
    },
  );
}