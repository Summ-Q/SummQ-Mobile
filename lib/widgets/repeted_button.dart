import 'package:flutter/material.dart';

Widget buildRepetitionButton({
  required String label,
  required Color color,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color.withOpacity(0.2),
      foregroundColor: color,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 1.5),
      ),
    ),
    child: Text(label),
  );
}