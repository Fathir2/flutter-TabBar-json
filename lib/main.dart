import 'package:flutter/material.dart';
import 'hal_kesehatan.dart'; // Import tab_screen.dart

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainTabBar(); // Panggil widget MainTabBar dari tab_screen.da// Panggil widget MainTabBar dari tab_screen.dart
  }
}
