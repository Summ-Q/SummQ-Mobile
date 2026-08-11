import 'dart:ui';
import 'package:flutter/material.dart';

Widget buildRepetitionButton(String label, Color color) {
  return ElevatedButton(
    onPressed: () {
      // TODO: Send data to Laravel & DS Python script here!
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: color.withOpacity(0.2), // Semi-transparent background
      foregroundColor: color, // Text color matches the difficulty
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 1.5),
      ),
    ),
    child: Text(label),
  );
}