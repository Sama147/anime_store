
import 'package:flutter/material.dart';
import 'package:anime_store/pages/home_page.dart'; // Import the new file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Store',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const HomePage(), // <--- Set the entry point
    );
  }
}