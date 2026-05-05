import 'package:flutter/material.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A237E),
      body: Center(
        child: Text(
          'Task List',
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
}
