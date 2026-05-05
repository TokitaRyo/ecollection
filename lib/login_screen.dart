import 'package:flutter/material.dart';
import 'accont_screen.dart';

class AppColors {
  static const navy = Color(0xFF00245A);
  static const middleBlue = Color(0xFF2E4F8F);
  static const lightBlue = Color(0xFF657CC0);
  static const pink = Color(0xFFFF9BE0);
  static const hotPink = Color(0xFFF05C9B);
  static const whitePink = Color(0xFFFFF4FF);
  static const palePurple = Color(0xFFD5CFE2);
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
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
                const SizedBox(height: 22),
                const Icon(
                  Icons.public_off_rounded,
                  color: AppColors.hotPink,
                  size: 82,
                ),
                const SizedBox(height: 22),
                const Text(
                  'Please verify your Internet\nconnection then retry',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 26),
                PinkButton(
                  text: 'Retry',
                  height: 60,
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

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        children: [
          const SizedBox(height: 48),
          const AppLogo(size: 190),
          const SizedBox(height: 24),
          const Text(
            'Log in',
            style: TextStyle(
              color: AppColors.pink,
              fontSize: 54,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 68),
          const AuthInput(
            label: 'Email',
            hint: 'Please enter your email',
            icon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: 34),
          const AuthInput(
            label: 'Password',
            hint: 'Please enter your password',
            icon: Icons.lock_outline_rounded,
            obscure: true,
          ),
          const SizedBox(height: 105),
          PinkButton(
            text: 'Sign up',
            onTap: () {
              showNoInternetDialog(context);
            },
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'You don’t have account ? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
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
      backgroundColor: AppColors.navy,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 430,
          ),
          child: Stack(
            children: [
              Positioned(
                left: -120,
                right: -120,
                bottom: -210,
                child: Container(
                  height: 510,
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
                  height: 310,
                  decoration: const BoxDecoration(
                    color: AppColors.middleBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: child,
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
          padding: const EdgeInsets.only(left: 18, bottom: 5),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.pink,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          height: 78,
          decoration: BoxDecoration(
            color: AppColors.whitePink,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.palePurple,
              width: 5,
            ),
          ),
          child: TextField(
            obscureText: obscure,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 10),
                child: Icon(
                  icon,
                  color: AppColors.palePurple,
                  size: 42,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 86,
              ),
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.palePurple,
                fontSize: 22,
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
    this.height = 82,
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
              fontSize: 28,
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
    return CustomPaint(
      size: Size(size, size),
      painter: LogoPainter(),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pinkStroke = Paint()
      ..color = AppColors.hotPink
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.075
      ..strokeCap = StrokeCap.round;

    final pinkFill = Paint()
      ..color = AppColors.pink
      ..style = PaintingStyle.fill;

    final whiteFill = Paint()
      ..color = AppColors.whitePink
      ..style = PaintingStyle.fill;

    final grayFill = Paint()
      ..color = AppColors.palePurple
      ..style = PaintingStyle.fill;

    final navyStroke = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.018
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: size.width * 0.42,
      ),
      2.0,
      4.75,
      false,
      pinkStroke,
    );

    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.18),
      size.width * 0.07,
      pinkFill,
    );

    final leftHill = Path()
      ..moveTo(size.width * 0.12, size.height * 0.68)
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.55,
        size.width * 0.54,
        size.height * 0.72,
      )
      ..lineTo(size.width * 0.12, size.height * 0.72)
      ..close();

    final rightHill = Path()
      ..moveTo(size.width * 0.38, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.62,
        size.height * 0.55,
        size.width * 0.88,
        size.height * 0.70,
      )
      ..lineTo(size.width * 0.88, size.height * 0.72)
      ..close();

    canvas.drawPath(leftHill, whiteFill);
    canvas.drawPath(rightHill, grayFill);

    final stem = Path()
      ..moveTo(size.width * 0.47, size.height * 0.70)
      ..cubicTo(
        size.width * 0.48,
        size.height * 0.52,
        size.width * 0.56,
        size.height * 0.40,
        size.width * 0.72,
        size.height * 0.29,
      );

    canvas.drawPath(
      stem,
      Paint()
        ..color = AppColors.pink
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.04
        ..strokeCap = StrokeCap.round,
    );

    final bigLeaf = Path()
      ..moveTo(size.width * 0.48, size.height * 0.53)
      ..cubicTo(
        size.width * 0.56,
        size.height * 0.25,
        size.width * 0.82,
        size.height * 0.25,
        size.width * 0.76,
        size.height * 0.40,
      )
      ..cubicTo(
        size.width * 0.69,
        size.height * 0.60,
        size.width * 0.53,
        size.height * 0.56,
        size.width * 0.48,
        size.height * 0.53,
      );

    canvas.drawPath(bigLeaf, pinkFill);

    final smallLeaf = Path()
      ..moveTo(size.width * 0.40, size.height * 0.52)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.47,
        size.width * 0.24,
        size.height * 0.35,
        size.width * 0.27,
        size.height * 0.36,
      )
      ..cubicTo(
        size.width * 0.42,
        size.height * 0.37,
        size.width * 0.46,
        size.height * 0.48,
        size.width * 0.40,
        size.height * 0.52,
      );

    canvas.drawPath(smallLeaf, pinkFill);

    canvas.drawLine(
      Offset(size.width * 0.58, size.height * 0.48),
      Offset(size.width * 0.72, size.height * 0.34),
      navyStroke,
    );

    canvas.drawLine(
      Offset(size.width * 0.39, size.height * 0.48),
      Offset(size.width * 0.30, size.height * 0.42),
      navyStroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}