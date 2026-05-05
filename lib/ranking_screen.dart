import 'package:flutter/material.dart';
import 'login_screen.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Stack(
            children: [
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BottomWaveBackground(),
              ),

              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: RankingHeader(),
              ),

              const Positioned(
                top: 112,
                left: 0,
                right: 0,
                child: PodiumSection(),
              ),

              // ランキング一覧：前より約3mm下げた
              const Positioned(
                top: 442,
                left: 0,
                right: 0,
                bottom: 256,
                child: RankingScrollList(),
              ),

              // 下ボタンを上げた分、テキストも上へ
              const Positioned(
                left: 0,
                right: 0,
                bottom: 206,
                child: Text(
                  'Actualized every 2 hours',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.palePurple,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              // 下ナビ：約1cm上へ
              const Positioned(
                left: 0,
                right: 0,
                bottom: 84,
                child: BottomNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomWaveBackground extends StatelessWidget {
  const BottomWaveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Stack(
        children: [
          Positioned(
            left: -100,
            right: -100,
            top: 0,
            child: Container(
              height: 210,
              decoration: const BoxDecoration(
                color: AppColors.middleBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(260, 85),
                  topRight: Radius.elliptical(260, 85),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RankingHeader extends StatelessWidget {
  const RankingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: Stack(
        children: [
          Positioned(
            left: -20,
            right: 0,
            top: 46,
            child: Container(
              height: 34,
              color: AppColors.lightBlue,
            ),
          ),
          Positioned(
            left: 12,
            top: 10,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.whitePink,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.lightBlue,
                  width: 6,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 118,
            top: 49,
            child: Text(
              '9.999.999 points',
              style: TextStyle(
                color: AppColors.hotPink,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Positioned(
            right: 12,
            top: 20,
            child: Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.deepOrange,
                  size: 32,
                ),
                Text(
                  '25',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PodiumSection extends StatelessWidget {
  const PodiumSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 392,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.pink,
                borderRadius: BorderRadius.circular(130),
              ),
            ),
          ),

          Positioned(
            bottom: 28,
            left: 36,
            child: Transform(
              transform: Matrix4.skewX(-0.08),
              child: Container(
                width: 132,
                height: 68,
                color: const Color(0xFFD98722),
                child: const Center(
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 28,
            right: 37,
            child: Transform(
              transform: Matrix4.skewX(0.05),
              child: Container(
                width: 132,
                height: 88,
                color: const Color(0xFFC9C9C9),
                child: const Center(
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 28,
            left: 158,
            child: Transform(
              transform: Matrix4.skewX(-0.05),
              child: Container(
                width: 100,
                height: 124,
                color: const Color(0xFFD1D63E),
                child: const Center(
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Positioned(
            top: 28,
            left: 166,
            child: RankCircle(
              name: 'Name',
              score: '15b',
              size: 86,
              nameSize: 20,
            ),
          ),
          const Positioned(
            top: 68,
            right: 44,
            child: RankCircle(
              name: 'Name',
              score: '14.7b',
              size: 82,
              nameSize: 20,
            ),
          ),
          const Positioned(
            top: 88,
            left: 44,
            child: RankCircle(
              name: 'Name',
              score: '12.3b',
              size: 82,
              nameSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class RankCircle extends StatelessWidget {
  final String name;
  final String score;
  final double size;
  final double nameSize;

  const RankCircle({
    super.key,
    required this.name,
    required this.score,
    required this.size,
    required this.nameSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: nameSize,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              score,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RankingScrollList extends StatefulWidget {
  const RankingScrollList({super.key});

  @override
  State<RankingScrollList> createState() => _RankingScrollListState();
}

class _RankingScrollListState extends State<RankingScrollList> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String scoreForRank(int rank) {
    if (rank == 4) return '10b';
    if (rank == 5) return '9.5b';
    if (rank == 6) return '9.4b';
    if (rank == 7) return '9.4b';
    if (rank == 8) return '9.2b';
    if (rank == 9) return '8.8b';
    if (rank == 10) return '8.6b';

    final value = (8.6 - (rank - 10) * 0.08).clamp(0.1, 8.6);
    return '${value.toStringAsFixed(1)}b';
  }

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: _controller,
      thumbVisibility: true,
      trackVisibility: false,
      thickness: 6,
      radius: const Radius.circular(99),
      thumbColor: AppColors.lightBlue,
      scrollbarOrientation: ScrollbarOrientation.left,
      child: ListView.builder(
        controller: _controller,
        padding: const EdgeInsets.only(
          left: 18,
          right: 0,
          bottom: 18,
        ),
        itemCount: 97,
        itemBuilder: (context, index) {
          final rank = index + 4;

          return RankingListItem(
            rank: rank.toString(),
            name: 'Name',
            score: scoreForRank(rank),
          );
        },
      ),
    );
  }
}

class RankingListItem extends StatelessWidget {
  final String rank;
  final String name;
  final String score;

  const RankingListItem({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.middleBlue,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.lightBlue,
          width: 5,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 46,
            child: Text(
              rank,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: AppColors.pink,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            score,
            style: const TextStyle(
              color: AppColors.palePurple,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavCircleButton(
            icon: Icons.emoji_events_outlined,
            onTap: () {},
          ),
          NavCircleButton(
            icon: Icons.home_outlined,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          NavCircleButton(
            icon: Icons.format_list_bulleted_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class NavCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const NavCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          color: AppColors.pink,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.hotPink,
            width: 8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              offset: const Offset(0, 6),
              blurRadius: 7,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppColors.navy,
          size: 47,
        ),
      ),
    );
  }
}