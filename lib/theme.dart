import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color navy = Color(0xFF0E1E45);
  static const Color cream = Color(0xFFEFE6D6);
  static const Color orangCream = Color(0xFFd5bb8b);
  static const Color creamText = Color(0xFF0E1E45);
  static const Color gold = Color(0xFFE9D9A8);
  static const Color yellowLink = Color(0xFFF2C744);
  static const Color subtitleGrey = Color(0xFFB9C0D4);
  static const Color green = Color(0xFF3FAE4A);
  static const Color greyCard = Color(0xFF54607D);
  static const Color lightBlue = Color(0xFF6FC7E6);
  static const Color yellowCard = Color(0xFFE8C24B);
  static const Color chartGreen = Color(0xFF3FAE4A);
  static const Color chartRed = Color(0xFFE3543E);
  static const Color gridBlue = Color(0xFF25376E);
  static const Color bottomBarBg = Color(0xFFEFE6D6);

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: navy,
      primaryColor: yellowCard,

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: bottomBarBg, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: yellowCard,
        foregroundColor: navy,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: yellowCard,
          foregroundColor: navy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

TextStyle appFont({
  required double size,
  required FontWeight weight,
  Color color = Colors.white,
  double? letterSpacing,
}) {
  return GoogleFonts.baloo2(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
  );
}

class SummQTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscure;
  final TextEditingController? controller;

  const SummQTextField({
    super.key,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.controller, required TextInputType keyboardType, required String? Function(String?) validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: appFont(size: 15, weight: FontWeight.w600, color: Colors.white)),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: appFont(size: 15, weight: FontWeight.w600, color: AppColors.creamText),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: appFont(size: 15, weight: FontWeight.w500, color: AppColors.creamText.withOpacity(0.55)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class SummQButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SummQButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cream,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Text(text, style: appFont(size: 18, weight: FontWeight.w700, color: AppColors.creamText)),
      ),
    );
  }
}
