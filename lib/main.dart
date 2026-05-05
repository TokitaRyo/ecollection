import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'badge.dart';
import 'tasklist_screen.dart';
import 'ranking_screen.dart';
import 'account_screen.dart';
import 'login_screen.dart';
import 'services/auth_service.dart';
import 'services/user_session.dart';
import 'widgets/shared_widgets.dart';

bool _startLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await AuthService.init();

  if (AuthService.isLoggedIn) {
    try {
      await UserSession().loadProfile();
      _startLoggedIn = true;
    } catch (_) {
      // Token probablement expiré → on tente un refresh
      if (await AuthService.tryRefresh()) {
        try {
          await UserSession().loadProfile();
          _startLoggedIn = true;
        } catch (_) {
          await AuthService.signOut();
        }
      } else {
        await AuthService.signOut();
      }
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecollection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.indigo,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.pinkAccent,
          surface: AppColors.indigo,
        ),
      ),
      home: _startLoggedIn ? const TaskListScreen() : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/tasks': (context) => const TaskListScreen(),
        '/badges': (context) => const BadgeListScreen(),
        '/ranking': (context) => const RankingScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
