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
    );
  }
}
