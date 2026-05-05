import 'package:flutter/material.dart';

class RankingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A237E),
      body: Center(
        child: Text(
          'Ranking',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
