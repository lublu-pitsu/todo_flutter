import 'package:flutter/material.dart';

import 'todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Список задач',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 50, 231, 165),
        ),
        useMaterial3: true,
      ),
      home: TodoScreen(),
    );
  }
}
