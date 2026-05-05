import 'package:flutter/material.dart';
import 'badge.dart';
import 'tasklist_screen.dart';
import 'ranking_screen.dart';
import 'account_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecollection',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => BadgeListScreen(),
        '/tasks': (context) => TaskListScreen(),
        '/ranking': (context) => RankingScreen(),
        '/account': (context) => AccountScreen(),
      },
    );
  }
}
