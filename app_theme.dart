import 'package:flutter/material.dart';

class AppColors {
  // HOME / DASHBOARD — Deep purple + warm accents
  static const Color homeBg = Color(0xFF312C51);
  static const Color homeSurface = Color(0xFF48426D);
  static const Color homeAccent1 = Color(0xFFF0C38E);
  static const Color homeAccent2 = Color(0xFFF1AA9B);
  static const Color homeText = Color(0xFFFFFFFF);

  // NOVELS — Dark + Electric Blue
  static const Color novelBg = Color(0xFF080F1A);
  static const Color novelSurface = Color(0xFF0D1B2E);
  static const Color novelAccent1 = Color(0xFF52E8FF);
  static const Color novelAccent2 = Color(0xFF007BA7);
  static const Color novelText = Color(0xFFFFFFFF);

  // ARTICLES — Warm Cream/Brown
  static const Color articleBg = Color(0xFFF5ECD7);
  static const Color articleSurface = Color(0xFFE8D5B5);
  static const Color articleAccent1 = Color(0xFF5C3D2E);
  static const Color articleAccent2 = Color(0xFFC4A882);
  static const Color articleText = Color(0xFF2C1810);

  // AUDIO PLAYER & GALLERY — Dark + Neon Purple
  static const Color audioBg = Color(0xFF090820);
  static const Color audioSurface = Color(0xFF120F35);
  static const Color audioAccent1 = Color(0xFF7030EF);
  static const Color audioAccent2 = Color(0xFFDB1FFF);
  static const Color audioText = Color(0xFFFFFFFF);

  // SHORT STORIES — Warm dark tones
  static const Color storyBg = Color(0xFF1A1220);
  static const Color storySurface = Color(0xFF261A30);
  static const Color storyAccent1 = Color(0xFFE8A87C);
  static const Color storyAccent2 = Color(0xFFB06ABE);
  static const Color storyText = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData homeTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.homeBg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.homeAccent1,
      secondary: AppColors.homeAccent2,
      surface: AppColors.homeSurface,
    ),
    fontFamily: 'GeneralSans',
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.homeText, fontWeight: FontWeight.w700),
      displayMedium: TextStyle(color: AppColors.homeText, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: AppColors.homeText),
      bodyMedium: TextStyle(color: AppColors.homeText),
    ),
  );

  static ThemeData novelTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.novelBg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.novelAccent1,
      secondary: AppColors.novelAccent2,
      surface: AppColors.novelSurface,
    ),
    fontFamily: 'GeneralSans',
  );

  static ThemeData articleTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.articleBg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.articleAccent1,
      secondary: AppColors.articleAccent2,
      surface: AppColors.articleSurface,
    ),
    fontFamily: 'GeneralSans',
  );

  static ThemeData audioTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.audioBg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.audioAccent1,
      secondary: AppColors.audioAccent2,
      surface: AppColors.audioSurface,
    ),
    fontFamily: 'GeneralSans',
  );
}
