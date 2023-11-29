import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texteditor/text_editin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          onPrimary: Colors.yellowAccent,
          secondary: Colors.blueAccent,
        ),
        textTheme: GoogleFonts.latoTextTheme(),
        useMaterial3: true,
      ),
      home: const TextEditingScreen(),
    );
  }
}
