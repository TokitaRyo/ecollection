import 'package:flutter/material.dart';
import 'login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        children: [
          const SizedBox(height: 8),
          const AppLogo(size: 120),
          const SizedBox(height: 8),
          const Text(
            'Create Account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.pink,
              fontSize: 37,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          const AuthInput(
            label: 'Email',
            hint: 'Please enter your email',
            icon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: 12),
          const AuthInput(
            label: 'Password',
            hint: 'Please enter your password',
            icon: Icons.lock_outline_rounded,
            obscure: true,
          ),
          const SizedBox(height: 16),
          Container(
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 36),
            decoration: BoxDecoration(
              color: AppColors.hotPink,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 12),
          const AuthInput(
            label: 'Nickname',
            hint: 'Please enter your nickname',
            icon: Icons.account_circle_outlined,
          ),
          const SizedBox(height: 28),
          PinkButton(
            text: 'Sign up',
            height: 70,
            onTap: () {
              showNoInternetDialog(context);
            },
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'Already have an account ? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Log in',
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