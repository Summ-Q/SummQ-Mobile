import 'dart:ui';
import 'package:flutter/material.dart';

Widget _buildLevelIndicator(Color color, String label) {
  return Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    ],
  );
}