import 'package:flutter/material.dart';
import 'login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const AppLogo(size: 180),
          const SizedBox(height: 26),
          const Text(
            'Create  Account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.pink,
              fontSize: 43,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 18),
          const AuthInput(
            label: 'Email',
            hint: 'Please enter your email',
            icon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: 28),
          const AuthInput(
            label: 'Password',
            hint: 'Please enter your password',
            icon: Icons.lock_outline_rounded,
            obscure: true,
          ),
          const SizedBox(height: 32),
          Container(
            height: 9,
            margin: const EdgeInsets.symmetric(horizontal: 38),
            decoration: BoxDecoration(
              color: AppColors.hotPink,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 26),
          const AuthInput(
            label: 'Nickname',
            hint: 'Please enter your nickname',
            icon: Icons.account_circle_outlined,
          ),
          const SizedBox(height: 55),
          PinkButton(
            text: 'Sign up',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'Already have an account ? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 45),
        ],
      ),
    );
  }
}