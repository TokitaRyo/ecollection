import 'package:flutter/material.dart';
import 'main.dart';

class Task {
  final String name;
  final String description;
  final String difficulty;
  final Color difficultyColor;
  final int targetSteps;
  final bool requiresLocation;
  final String rewardImage;
  int currentSteps;

  Task({
    required this.name,
    required this.description,
    required this.difficulty,
    required this.difficultyColor,
    required this.targetSteps,
    required this.rewardImage,
    this.requiresLocation = false,
    this.currentSteps = 0,
  });
}

class TaskListScreen extends StatefulWidget {
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool _homePositionSet = false;

  final List<Task> tasks = [
    Task(
      name: 'Little walker',
      description: 'Walk 3.000 steps in less than 24h.',
      difficulty: 'Easy',
      difficultyColor: Color(0xFF4CAF50),
      targetSteps: 3000,
      rewardImage: 'assets/badges/bird.png',
    ),
    Task(
      name: 'Speedrunner',
      description: 'Walk 2.000.000 in less than a month',
      difficulty: 'Infernal',
      difficultyColor: Color(0xFF7B1FA2),
      targetSteps: 2000000,
      rewardImage: 'assets/badges/ruby.png',
    ),
    Task(
      name: 'Bannished',
      description: 'Stay at least 30 km away from home.',
      difficulty: 'Hard',
      difficultyColor: Color(0xFFE53935),
      targetSteps: 0,
      requiresLocation: true,
      rewardImage: 'assets/badges/dog.png',
    ),
    Task(
      name: 'Climbing machine',
      description: 'Reach 500m of altitude in less than 24h.',
      difficulty: 'Medium',
      difficultyColor: Color(0xFF00BCD4),
      targetSteps: 500,
      rewardImage: 'assets/badges/cat.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (globalActiveTask != null) {
        _showTaskPopup(context, globalActiveTask!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A237E),
      body: SafeArea(
        child: Column(
          children: [
            _buildScoreBar(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Finish tasks to increase your score',
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Please chose a task',
                    style: TextStyle(
                      color: Color(0xFFFF80AB),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskCard(tasks[index]);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Reset in : 5d',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildTaskCard(Task task) {
    final bool isLocked = task.requiresLocation && !_homePositionSet;
    final bool isActive = globalActiveTask?.name == task.name;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLocked
            ? Color(0xFF283593).withOpacity(0.5)
            : Color(0xFF283593),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.name,
                style: TextStyle(
                  color: isLocked ? Colors.white38 : Colors.white70,
                  fontSize: 18,
                ),
              ),
              Text(
                task.difficulty,
                style: TextStyle(
                  color: task.difficultyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            task.description,
            style: TextStyle(
              color: isLocked ? Colors.white24 : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (isLocked)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'Please configure your home position to unlock this task',
                style: TextStyle(
                  color: Color(0xFFFF80AB),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Reward + バッジ画像
              Row(
                children: [
                  Text(
                    'Reward :',
                    style: TextStyle(
                      color: Color(0xFFFF80AB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      task.rewardImage,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.none,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF80AB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Accept task ボタン
              ElevatedButton(
                onPressed: isLocked
                    ? null
                    : () => _showTaskPopup(context, task),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive
                      ? Color(0xFFFF80AB).withOpacity(0.6)
                      : isLocked
                      ? Color(0xFFFF80AB).withOpacity(0.4)
                      : Color(0xFFFF80AB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  isActive ? 'In progress' : 'Accept task',
                  style: TextStyle(
                    color: Color(0xFF1A237E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTaskPopup(BuildContext context, Task task) {
    final navigatorContext = context;
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          final bool isActive = globalActiveTask?.name == task.name;
          final double progress = task.targetSteps > 0
              ? task.currentSteps / task.targetSteps
              : 0;
          final int percent = (progress * 100).toInt();

          return Dialog(
            backgroundColor: Color(0xFF283593),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    task.description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Reward :',
                    style: TextStyle(
                      color: Color(0xFFFF80AB),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // ポップアップのバッジ画像
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      task.rewardImage,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.none,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF80AB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),

                  if (isActive) ...[
                    Center(
                      child: Text(
                        '${task.currentSteps}/${task.targetSteps}',
                        style: TextStyle(
                          color: Color(0xFFFF80AB),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progress.clamp(0.0, 1.0),
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          top: 2,
                          child: Text(
                            '$percent%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Remaining time :',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '18 : 13 : 03',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await Future.delayed(Duration(milliseconds: 200));
                          _showCancelConfirm(navigatorContext, task);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF80AB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Cancel task',
                          style: TextStyle(
                            color: Color(0xFF1A237E),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],

                  if (!isActive) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => globalActiveTask = task);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF80AB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Accept task',
                          style: TextStyle(
                            color: Color(0xFF1A237E),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCancelConfirm(BuildContext context, Task task) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => Dialog(
        backgroundColor: Color(0xFF283593),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Cancel the task ?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'If you really want to cancel the task click on Confirm',
                style: TextStyle(color: Colors.white70, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() => globalActiveTask = null);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF80AB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Color(0xFF1A237E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF80AB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF1A237E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
          _navButton(context, Icons.home, '/tasks'),
          _navButton(context, Icons.list, '/home'),
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
