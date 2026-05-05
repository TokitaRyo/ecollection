import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const ParrsApp());
}

class ParrsApp extends StatelessWidget {
  const ParrsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PARRS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const LoginScreen(),
    );
  }
}