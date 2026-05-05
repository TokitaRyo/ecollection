import 'package:flutter/material.dart';

class AppColors {
  // Main app colors
  static const navy = Color(0xFF00245A);
  static const indigo = Color(0xFF1A237E);
  static const indigoDark = Color(0xFF283593);
  static const lightBlue = Color(0xFF657CC0);
  static const middleBlue = Color(0xFF2E4F8F);

  // Accents
  static const pink = Color(0xFFFF9BE0);
  static const hotPink = Color(0xFFF05C9B);
  static const pinkAccent = Color(0xFFFF80AB);

  // Neutrals
  static const whitePink = Color(0xFFFFF4FF);
  static const palePurple = Color(0xFFD5CFE2);
}

class ScoreBar extends StatelessWidget {
  final int score;
  final int streak;
  final String? avatarUrl;

  const ScoreBar({
    super.key,
    required this.score,
    required this.streak,
    this.avatarUrl,
  });

  String _formatScore(int score) {
    if (score >= 1000000000) {
      return '${(score / 1000000000).toStringAsFixed(1)}b';
    } else if (score >= 1000000) {
      return '${(score / 1000000).toStringAsFixed(1)}m';
    } else if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(1)}k';
    }
    return score.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.indigoDark,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? const Icon(Icons.person, color: AppColors.indigoDark, size: 28)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_formatScore(score)} points',
            style: const TextStyle(
              color: AppColors.pinkAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.local_fire_department, color: Colors.orange),
          Text(
            '$streak',
            style: const TextStyle(
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

class AppBottomNav extends StatelessWidget {
  final String currentRoute;

  const AppBottomNav({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.indigo,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navButton(context, Icons.emoji_events, '/ranking'),
          _navButton(context, Icons.home, '/tasks'),
          _navButton(context, Icons.collections_bookmark, '/badges'),
        ],
      ),
    );
  }

  Widget _navButton(BuildContext context, IconData icon, String route) {
    final isActive = currentRoute == route;
    return GestureDetector(
      onTap: () {
        if (route != currentRoute) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: isActive ? AppColors.hotPink : AppColors.pinkAccent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.indigo, size: 30),
      ),
    );
  }
}
