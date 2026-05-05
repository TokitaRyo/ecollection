import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'services/user_session.dart';
import 'widgets/shared_widgets.dart';

class BadgeListScreen extends StatefulWidget {
  const BadgeListScreen({super.key});

  @override
  State<BadgeListScreen> createState() => _BadgeListScreenState();
}

class _BadgeListScreenState extends State<BadgeListScreen> {
  List<dynamic> _badges = [];
  bool _loading = true;
  int _selectedBadgeIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadBadges();
  }

  Future<void> _loadBadges() async {
    setState(() => _loading = true);
    try {
      final badges = await ApiService.getMyBadges();
      setState(() {
        _badges = badges;
        _loading = false;
        _selectedBadgeIndex = 0;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Color _rarityColor(String rarity) {
    switch (rarity) {
      case 'Common':
        return const Color(0xFF9E9E9E);
      case 'Rare':
        return const Color(0xFF1565C0);
      case 'Epic':
        return const Color(0xFF6A1B9A);
      case 'Legendary':
        return const Color(0xFFE65100);
      case 'SSR':
        return const Color(0xFFFFD700);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = UserSession();
    final selected = _badges.isNotEmpty ? _badges[_selectedBadgeIndex] : null;

    return Scaffold(
      backgroundColor: AppColors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            ScoreBar(
              score: session.score,
              streak: session.streak,
              avatarUrl: session.avatarUrl,
            ),
            if (_loading)
              const Expanded(
                child: Center(child: CircularProgressIndicator(color: AppColors.pinkAccent)),
              )
            else if (_badges.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.collections_bookmark, color: Colors.white38, size: 64),
                      SizedBox(height: 16),
                      Text(
                        'No badges yet',
                        style: TextStyle(color: Colors.white60, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Complete tasks to earn badges!',
                        style: TextStyle(color: Colors.white38, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              if (selected != null) _buildBadgeDetailCard(selected),
              const SizedBox(height: 12),
              Expanded(child: _buildBadgeGrid()),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentRoute: '/badges'),
    );
  }

  Widget _buildBadgeDetailCard(Map<String, dynamic> badge) {
    final String rarity = badge['rarity'] ?? 'Common';
    final Color color = _rarityColor(rarity);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.indigoDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.pinkAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: badge['imageName'] != null
                      ? Image.asset(
                          'assets/badges/${badge['imageName']}',
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.none,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 40,
                          ),
                        )
                      : const Icon(Icons.image, color: Colors.white, size: 40),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      badge['name'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      rarity,
                      style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: color, blurRadius: 8)],
                      ),
                    ),
                    if (badge['quantity'] != null && badge['quantity'] > 1)
                      Text(
                        'x${badge['quantity']}',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            badge['description'] ?? '',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          if (badge['obtention'] != null) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Obtained : ${_formatDate(badge['obtention'])}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  Widget _buildBadgeGrid() {
    return Column(
      children: [
        Text(
          'Your badges (${_badges.length})',
          style: const TextStyle(
            color: AppColors.pinkAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _badges.length,
            itemBuilder: (context, index) {
              final badge = _badges[index];
              return GestureDetector(
                onTap: () => setState(() => _selectedBadgeIndex = index),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.pinkAccent,
                    borderRadius: BorderRadius.circular(16),
                    border: _selectedBadgeIndex == index
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: badge['imageName'] != null
                        ? Image.asset(
                            'assets/badges/${badge['imageName']}',
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.none,
                            errorBuilder: (_, __, ___) =>
                                Container(color: AppColors.pinkAccent),
                          )
                        : Container(color: AppColors.pinkAccent),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
