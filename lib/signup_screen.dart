import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/user_session.dart';
import 'widgets/shared_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  bool _loading = false;

  Future<void> _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final nickname = _nicknameController.text.trim();

    if (email.isEmpty || password.isEmpty || nickname.isEmpty) {
      _showError('Please fill all fields');
      return;
    }

    setState(() => _loading = true);

    try {
      await ApiService.register(
        email: email,
        password: password,
        nickname: nickname,
      );
      await AuthService.signIn(email: email, password: password);
      await UserSession().loadProfile();

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/tasks', (route) => false);
      }
    } on ApiException catch (e) {
      if (mounted) _showError(e.message);
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const Spacer(flex: 1),
            const AppLogo(size: 110),
            const SizedBox(height: 8),
            const Text(
              'Create Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.pink,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const Spacer(flex: 1),
            AuthInput(
              label: 'Email',
              hint: 'Please enter your email',
              icon: Icons.mail_outline_rounded,
              controller: _emailController,
            ),
            const SizedBox(height: 14),
            AuthInput(
              label: 'Password',
              hint: 'Please enter your password',
              icon: Icons.lock_outline_rounded,
              obscure: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 14),
            AuthInput(
              label: 'Nickname',
              hint: 'Please enter your nickname',
              icon: Icons.account_circle_outlined,
              controller: _nicknameController,
            ),
            const Spacer(flex: 2),
            _loading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: CircularProgressIndicator(color: AppColors.pink),
                  )
                : PinkButton(text: 'Sign up', onTap: _signup, height: 64),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                const Text(
                  'Already have an account ? ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Log in',
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
