import 'package:flutter/material.dart';

class BadgeItem {
  final String name;
  final String rarity;
  final String description;
  final String condition;
  final String obtainedDate;
  final Color rarityColor;
  final String imagePath;

  BadgeItem({
    required this.name,
    required this.rarity,
    required this.description,
    required this.condition,
    required this.obtainedDate,
    required this.rarityColor,
    required this.imagePath,
  });
}

class BadgeListScreen extends StatefulWidget {
  @override
  State<BadgeListScreen> createState() => _BadgeListScreenState();
}

class _BadgeListScreenState extends State<BadgeListScreen> {
  int _selectedBadgeIndex = 0;
  int _categoryIndex = 0;

  final List<String> categories = [
    'Special',
    'Animal',
    'Juelly',
    'Smile',
    'Fruits',
  ];

  final Map<String, List<BadgeItem>> badgeMap = {
    'Special': [
      BadgeItem(
        name: 'Badge S1',
        rarity: 'SSR',
        description: 'A mysterious special badge.',
        condition: 'Walk 2,000,000 in less than a month',
        obtainedDate: '05/05/2026',
        rarityColor: Color(0xFFFFD700),
        imagePath: 'assets/badges/special_1.png', // 画像未定
      ),
      BadgeItem(
        name: 'Badge S2',
        rarity: 'SSR',
        description: 'An extraordinary special badge.',
        condition: 'Complete all tasks in a week',
        obtainedDate: '05/05/2026',
        rarityColor: Color(0xFFFFD700),
        imagePath: 'assets/badges/special_2.png', // 画像未定
      ),
    ],
    'Animal': [
      BadgeItem(
        name: 'Bird',
        rarity: 'Common',
        description: 'Free as a bird.',
        condition: 'Walk 5,000 steps in a day',
        obtainedDate: '01/05/2026',
        rarityColor: Color(0xFF9E9E9E),
        imagePath: 'assets/badges/bird.png',
      ),
      BadgeItem(
        name: 'Cat',
        rarity: 'Rare',
        description: 'Graceful and swift.',
        condition: 'Walk 10,000 steps in a day',
        obtainedDate: '02/05/2026',
        rarityColor: Color(0xFF1565C0),
        imagePath: 'assets/badges/cat.png',
      ),
      BadgeItem(
        name: 'Dog',
        rarity: 'Epic',
        description: 'Loyal and strong.',
        condition: 'Walk 30,000 steps in a day',
        obtainedDate: '03/05/2026',
        rarityColor: Color(0xFF6A1B9A),
        imagePath: 'assets/badges/dog.png',
      ),
    ],
    'Juelly': [
      BadgeItem(
        name: 'Diamond',
        rarity: 'Epic',
        description: 'Shining bright forever.',
        condition: 'Complete 30 tasks',
        obtainedDate: '03/05/2026',
        rarityColor: Color(0xFF6A1B9A),
        imagePath: 'assets/badges/diamond.png',
      ),
      BadgeItem(
        name: 'Ruby',
        rarity: 'Legendary',
        description: 'Rare and precious.',
        condition: 'Complete 100 tasks',
        obtainedDate: '04/05/2026',
        rarityColor: Color(0xFFE65100),
        imagePath: 'assets/badges/ruby.png',
      ),
    ],
    'Smile': [
      BadgeItem(
        name: 'Smile',
        rarity: 'Common',
        description: 'Spread happiness around you.',
        condition: 'Complete your first task',
        obtainedDate: '01/05/2026',
        rarityColor: Color(0xFF9E9E9E),
        imagePath: 'assets/badges/smile.png',
      ),
      BadgeItem(
        name: 'Sunglass',
        rarity: 'Rare',
        description: 'Cool and confident.',
        condition: 'Complete 10 tasks',
        obtainedDate: '02/05/2026',
        rarityColor: Color(0xFF1565C0),
        imagePath: 'assets/badges/sunglass.png',
      ),
    ],
    'Fruits': [
      BadgeItem(
        name: 'Apple',
        rarity: 'Common',
        description: 'An apple a day keeps pollution away.',
        condition: 'Use reusable bag 5 times',
        obtainedDate: '01/05/2026',
        rarityColor: Color(0xFF9E9E9E),
        imagePath: 'assets/badges/apple.png',
      ),
      BadgeItem(
        name: 'Grape',
        rarity: 'Rare',
        description: 'Sweet rewards of effort.',
        condition: 'Eat meat-free for 7 days',
        obtainedDate: '02/05/2026',
        rarityColor: Color(0xFF1565C0),
        imagePath: 'assets/badges/grape.png',
      ),
      BadgeItem(
        name: 'Orange',
        rarity: 'Epic',
        description: 'Bursting with energy.',
        condition: 'Pick up litter 10 times',
        obtainedDate: '03/05/2026',
        rarityColor: Color(0xFF6A1B9A),
        imagePath: 'assets/badges/orange.png',
      ),
    ],
  };

  List<BadgeItem> get currentBadges =>
      badgeMap[categories[_categoryIndex]] ?? [];

  void _prevCategory() {
    setState(() {
      _categoryIndex =
          (_categoryIndex - 1 + categories.length) % categories.length;
      _selectedBadgeIndex = 0;
    });
  }

  void _nextCategory() {
    setState(() {
      _categoryIndex = (_categoryIndex + 1) % categories.length;
      _selectedBadgeIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = currentBadges.isNotEmpty
        ? currentBadges[_selectedBadgeIndex]
        : null;

    return Scaffold(
      backgroundColor: Color(0xFF1A237E),
      body: SafeArea(
        child: Column(
          children: [
            _buildScoreBar(),
            if (selected != null) _buildBadgeDetailCard(selected),
            SizedBox(height: 12),
            Expanded(child: _buildBadgeGrid()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildScoreBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Color(0xFF283593),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundColor: Colors.white),
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

  Widget _buildBadgeDetailCard(BadgeItem badge) {
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  badge.imagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.none,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF80AB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.image, color: Colors.white, size: 40),
                    );
                  },
                ),
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
          Text(
            badge.description,
            style: TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
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
                  categories[_categoryIndex],
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

  Widget _buildBadgeGrid() {
    return Column(
      children: [
        // カテゴリ切り替えボタン
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _prevCategory,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xFFFF80AB),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_left,
                  color: Color(0xFF1A237E),
                  size: 28,
                ),
              ),
            ),
            SizedBox(width: 16),
            Text(
              'Your badges : ${categories[_categoryIndex]}',
              style: TextStyle(
                color: Color(0xFFFF80AB),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: _nextCategory,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xFFFF80AB),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: Color(0xFF1A237E),
                  size: 28,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        // バッジグリッド
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: currentBadges.length,
            itemBuilder: (context, index) {
              final badge = currentBadges[index];
              return GestureDetector(
                onTap: () => setState(() => _selectedBadgeIndex = index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFF80AB),
                    borderRadius: BorderRadius.circular(16),
                    border: _selectedBadgeIndex == index
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      badge.imagePath,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.none,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Color(0xFFFF80AB));
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

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
          _navButton(Icons.emoji_events, () {
            Navigator.pushNamed(context, '/ranking');
          }),
          _navButton(Icons.home, () {
            Navigator.pushNamed(context, '/home');
          }),
          _navButton(Icons.list, () {
            Navigator.pushNamed(context, '/tasks');
          }),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
