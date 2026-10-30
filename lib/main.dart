import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme.dart';

void main() => runApp(const PinoteApp());

class PinoteApp extends StatelessWidget {
  const PinoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinote',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const SplashScreen(),
      builder: (context, child) {
        // Di HP asli/emulator: tampil normal.
        if (!kIsWeb) return child!;

        // Di browser: tampil seperti layar HP di tengah halaman.
        return Container(
          color: const Color(0xFFCDE9EA),
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 820),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: child!,
            ),
          ),
        );
      },
    );
  }
}