import 'package:flutter/material.dart';

// バッジのデータモデル
class Badge {
  final String name;
  final String rarity;
  final String description;
  final String condition;
  final String obtainedDate;
  final Color rarityColor;

  Badge({
    required this.name,
    required this.rarity,
    required this.description,
    required this.condition,
    required this.obtainedDate,
    required this.rarityColor,
  });
}

class BadgeListScreen extends StatefulWidget {
  @override
  State<BadgeListScreen> createState() => _BadgeListScreenState();
}

class _BadgeListScreenState extends State<BadgeListScreen> {
  int _selectedIndex = 0;

  // サンプルバッジデータ
  final List<Badge> badges = [
    Badge(
      name: 'The Tarnished',
      rarity: 'SSR',
      description:
          'Foul tarnished, in search of the Elden Ring. Emboldened by the flame of ambition.',
      condition: 'Walk 2,000,000 in less than a month',
      obtainedDate: '05/05/2026',
      rarityColor: Color(0xFFFFD700),
    ),
    Badge(
      name: 'First Step',
      rarity: 'Common',
      description: 'Your journey begins with a single step.',
      condition: 'Complete your first eco task',
      obtainedDate: '01/05/2026',
      rarityColor: Color(0xFF9E9E9E),
    ),
    Badge(
      name: 'Ocean Hero',
      rarity: 'Epic',
      description: 'Guardian of the seas.',
      condition: 'Pick up litter 10 times',
      obtainedDate: '03/05/2026',
      rarityColor: Color(0xFF6A1B9A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = badges[_selectedIndex];

    return Scaffold(
      backgroundColor: Color(0xFF1A237E),
      body: SafeArea(
        child: Column(
          children: [
            // ── スコアバー ──
            _buildScoreBar(),

            // ── 選択中バッジの詳細カード ──
            _buildBadgeDetailCard(selected),

            SizedBox(height: 12),

            // ── バッジグリッド ──
            Expanded(child: _buildBadgeGrid()),
          ],
        ),
      ),

      // ── 下部ナビ ──
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // スコアバー
  Widget _buildScoreBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Color(0xFF283593),
      child: Row(
        children: [
          // プロフィール画像
          CircleAvatar(radius: 28, backgroundColor: Colors.white),
          SizedBox(width: 12),
          // スコア
          Text(
            '9.999.999 points',
            style: TextStyle(
              color: Color(0xFFFF80AB),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          // ストリーク
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

  // バッジ詳細カード
  Widget _buildBadgeDetailCard(Badge badge) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF283593),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // バッジ画像
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFFF80AB),
                  borderRadius: BorderRadius.circular(12),
                ),
                // Image.asset('assets/badges/${badge.name}.png') に変更可能
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      badge.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // レアリティ表示
                    Text(
                      badge.rarity,
                      style: TextStyle(
                        color: badge.rarityColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: badge.rarityColor, blurRadius: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // 説明文
          Text(
            badge.description,
            style: TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          // 取得条件
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF3949AB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  'Speedrunner',
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
                Text(
                  badge.condition,
                  style: TextStyle(
                    color: Color(0xFFFF80AB),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // 取得日
          Center(
            child: Text(
              'Obtained : ${badge.obtainedDate}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // バッジグリッド
  Widget _buildBadgeGrid() {
    return Column(
      children: [
        Text(
          'Your badges : Special',
          style: TextStyle(
            color: Color(0xFFFF80AB),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFF80AB),
                    borderRadius: BorderRadius.circular(16),
                    border: _selectedIndex == index
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                  // Image.asset('assets/badges/...') に変更可能
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 下部ナビ
  Widget _buildBottomNav() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF1A237E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navButton(Icons.emoji_events),
          _navButton(Icons.home),
          _navButton(Icons.list),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Color(0xFFFF80AB),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Color(0xFF1A237E), size: 30),
    );
  }
}
