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
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFF1A237E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navButton(context, Icons.emoji_events, '/ranking'),
            _navButton(context, Icons.home, '/home'),
            _navButton(context, Icons.list, '/tasks'),
            _navButton(context, Icons.person, '/account'),
          ],
        ),
      ),
    );
  }

  Widget _navButton(BuildContext context, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Color(0xFFFF80AB),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Color(0xFF1A237E), size: 30),
      ),
    );
  }

  Widget _buildScoreBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Color(0xFF283593),
      child: Row(
        children: [
          // ← タップでアカウント画面へ
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/account'),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF283593), size: 28),
            ),
          ),
          SizedBox(width: 12),
          Text(
            '9.999.999 points',
            style: TextStyle(
              color: Color(0xFFFF80AB),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Icon(Icons.local_fire_department, color: Colors.orange),
          Text(
            '25',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
