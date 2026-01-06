import 'package:flutter/material.dart';
import 'screens/screen.dart'; // <--- Aponta para a pasta screens

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo REST Organizado',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const PostListScreen(), // Chama a tela que criamos
    );
  }
}
