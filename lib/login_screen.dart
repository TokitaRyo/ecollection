import 'package:flutter/material.dart';
import 'accont_screen.dart';
import 'ranking_screen.dart';

class AppColors {
  static const navy = Color(0xFF00245A);
  static const middleBlue = Color(0xFF2E4F8F);
  static const lightBlue = Color(0xFF657CC0);
  static const pink = Color(0xFFFF9BE0);
  static const hotPink = Color(0xFFF05C9B);
  static const whitePink = Color(0xFFFFF4FF);
  static const palePurple = Color(0xFFD5CFE2);
}

void showNoInternetDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.62),
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
          decoration: BoxDecoration(
            color: AppColors.middleBlue,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.lightBlue,
              width: 5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'No Internet connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.palePurple,
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.public_off_rounded,
                color: AppColors.hotPink,
                size: 82,
              ),
              const SizedBox(height: 20),
              const Text(
                'Please verify your Internet\nconnection then retry',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 24),
              PinkButton(
                text: 'Retry',
                height: 58,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        children: [
          const SizedBox(height: 10),

          const AppLogo(size: 135),

          const SizedBox(height: 10),

          const Text(
            'Log in',
            style: TextStyle(
              color: AppColors.pink,
              fontSize: 48,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 34),

          const AuthInput(
            label: 'Email',
            hint: 'Please enter your email',
            icon: Icons.mail_outline_rounded,
          ),

          const SizedBox(height: 16),

          const AuthInput(
            label: 'Password',
            hint: 'Please enter your password',
            icon: Icons.lock_outline_rounded,
            obscure: true,
          ),

          const SizedBox(height: 44),

          PinkButton(
            text: 'Log in',
            height: 70,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RankingScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'You don’t have account ? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AccountScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Create account',
                  style: TextStyle(
                    color: AppColors.hotPink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AuthScaffold extends StatelessWidget {
  final Widget child;

  const AuthScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.navy,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Stack(
            children: [
              Positioned(
                left: -150,
                right: -150,
                bottom: -260,
                child: Container(
                  height: 520,
                  decoration: const BoxDecoration(
                    color: AppColors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: -90,
                right: -90,
                bottom: 150,
                child: Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    color: AppColors.middleBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 390,
                      height: 780,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthInput extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;

  const AuthInput({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.pink,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          height: 66,
          decoration: BoxDecoration(
            color: AppColors.whitePink,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.palePurple,
              width: 5,
            ),
          ),
          child: TextField(
            obscureText: obscure,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14, right: 8),
                child: Icon(
                  icon,
                  color: AppColors.palePurple,
                  size: 36,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 70,
              ),
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.palePurple,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PinkButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double height;

  const PinkButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.pink,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.hotPink,
            width: 7,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.32),
              offset: const Offset(0, 7),
              blurRadius: 7,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/badges/image.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}