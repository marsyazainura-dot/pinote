import 'package:flutter/material.dart';

class AppColors {
  // Palet: F29191, F7ADAD, B1E5E6, CCFBFA (colorhunt.co)
  static const primary = Color(0xFFF29191); // coral: tombol, chip aktif, FAB
  static const primaryDark = Color(0xFFC85A5A); // coral tua: teks/ikon berwarna
  static const onPrimary = Color(0xFF3A1F1F); // teks di atas warna primary
  static const accent = Color(0xFFB1E5E6); // teal lembut
  static const tealDark = Color(0xFF2F7F82); // teks/ikon teal
  static const aqua = Color(0xFFCCFBFA);
  static const background = Color(0xFFF0FDFD);
  static const text = Color(0xFF1F3B3D);
  static const textMuted = Color(0xFF678486);
  static const border = Color(0xFFCDE9EA);
  static const danger = Color(0xFFD64545);

  // Warna catatan (pastel, dari palet)
  static const noteRose = Color(0xFFF7ADAD);
  static const noteTeal = Color(0xFFB1E5E6);
  static const noteAqua = Color(0xFFCCFBFA);
  static const noteBlush = Color(0xFFFCD5D5);
  static const noteCream = Color(0xFFFFF1DC);

  // Nama lama, supaya file lama tetap bisa dikompilasi
  static const noteYellow = noteCream;
  static const noteMint = noteTeal;
  static const notePink = noteBlush;
  static const noteBlue = noteAqua;
  static const notePurple = noteRose;

  static const noteColors = [
    noteRose,
    noteTeal,
    noteAqua,
    noteBlush,
    noteCream,
  ];
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );

  OutlineInputBorder border([Color c = AppColors.border]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c),
      );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
      border: border(),
      enabledBorder: border(),
      focusedBorder: border(AppColors.primary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      foregroundColor: AppColors.text,
      titleTextStyle: TextStyle(
        color: AppColors.text,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}