import 'package:flutter/material.dart';
import 'package:sudoku_solver/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sudoku Solver',
      home: HomeScreen(),
    );
  }
}
