import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'services/auth_service.dart';
import 'services/user_session.dart';
import 'widgets/shared_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    setState(() => _loading = true);

    try {
      await AuthService.signIn(email: email, password: password);
      await UserSession().loadProfile();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/tasks');
      }
    } on AuthException catch (e) {
      if (mounted) _showError(e.message);
    } catch (e) {
      if (mounted) {
        if (e.toString().contains('SocketException') ||
            e.toString().contains('network')) {
          _showNoInternetDialog();
        } else {
          _showError(e.toString());
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showNoInternetDialog() {
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
              border: Border.all(color: AppColors.lightBlue, width: 5),
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
                const Icon(Icons.public_off_rounded, color: AppColors.hotPink, size: 82),
                const SizedBox(height: 22),
                const Text(
                  'Please verify your Internet\nconnection then retry',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 22, height: 1.25),
                ),
                const SizedBox(height: 26),
                PinkButton(
                  text: 'Retry',
                  height: 60,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const Spacer(flex: 2),
            const AppLogo(size: 140),
            const SizedBox(height: 12),
            const Text(
              'Log in',
              style: TextStyle(
                color: AppColors.pink,
                fontSize: 48,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(flex: 2),
            AuthInput(
              label: 'Email',
              hint: 'Please enter your email',
              icon: Icons.mail_outline_rounded,
              controller: _emailController,
            ),
            const SizedBox(height: 18),
            AuthInput(
              label: 'Password',
              hint: 'Please enter your password',
              icon: Icons.lock_outline_rounded,
              obscure: true,
              controller: _passwordController,
            ),
            const Spacer(flex: 3),
            _loading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: CircularProgressIndicator(color: AppColors.pink),
                  )
                : PinkButton(text: 'Log in', onTap: _login, height: 70),
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                const Text(
                  "You don't have account ? ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    );
                  },
                  child: const Text(
                    'Create account',
                    style: TextStyle(
                      color: AppColors.hotPink,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

// ============================================
// Shared Auth Widgets
// ============================================

class AuthScaffold extends StatelessWidget {
  final Widget child;

  const AuthScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
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
              SafeArea(child: child),
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
  final TextEditingController? controller;

  const AuthInput({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.controller,
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
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.whitePink,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.palePurple, width: 4),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14, right: 8),
                child: Icon(icon, color: AppColors.palePurple, size: 32),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 56),
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.palePurple,
                fontSize: 17,
                fontWeight: FontWeight.w700,
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
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.hotPink, width: 6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.32),
              offset: const Offset(0, 6),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
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

  const AppLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/image.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
