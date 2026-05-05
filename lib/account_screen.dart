import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A237E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildScoreBar(context),
              SizedBox(height: 24),
              _buildProfileCard(context),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildScoreBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Color(0xFF283593),
      child: Row(
        children: [
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

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF283593),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 70, backgroundColor: Color(0xFFBDBDBD)),
          SizedBox(height: 16),
          _buildButton('Change avatar', () {}),
          SizedBox(height: 24),
          _buildInfoRow('Your name', 'Franclupin'),
          _buildInfoRow('Number of badges', '0'),
          _buildInfoRow('Inscription', '04/05/2026'),
          _buildInfoRow('Home position', 'Defined'),
          SizedBox(height: 24),
          _buildButton('Define home position', () {}),
          SizedBox(height: 12),
          _buildButton('Disconnect', () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }, color: Color(0xFFFF80AB).withOpacity(0.7)),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label : ',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String label,
    VoidCallback onTap, {
    Color color = const Color(0xFFFF80AB),
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 14),
          elevation: 4,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
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
