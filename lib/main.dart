import 'package:flutter/material.dart';
// Importer la page d'affichage des puzzles
import 'login/login.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WoodyCraft',
      home: LoginScreen(), 
    );
  }
}
