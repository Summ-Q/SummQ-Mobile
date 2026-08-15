import 'dart:ui';
import 'package:flutter/material.dart';

import '../theme.dart';

Widget buildSettingsRow({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  String? trailingText,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.greyCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: appFont(size: 15, weight: FontWeight.w600, color: Colors.white),
            ),
            const Spacer(),
            if (trailingText != null)
              Text(
                trailingText,
                style: appFont(size: 14, weight: FontWeight.w500, color: AppColors.subtitleGrey),
              )
            else
              const Icon(Icons.chevron_right_rounded, color: Colors.white70, size: 22),
          ],
        ),
      ),
    ),
  );
}

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16, left: 4),
    child: Text(
      title,
      style: appFont(size: 18, weight: FontWeight.w700, color: AppColors.gold),
    ),
  );
}



Widget buildSwitchRow({
  required IconData icon,
  required String label,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.greyCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 14),
          Text(
            label,
            style: appFont(size: 15, weight: FontWeight.w600, color: Colors.white),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.yellowLink,
            activeTrackColor: AppColors.yellowLink.withOpacity(0.3),
            inactiveThumbColor: AppColors.subtitleGrey,
            inactiveTrackColor: AppColors.navy,
          ),
        ],
      ),
    ),
  );
}