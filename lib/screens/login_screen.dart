import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/page_transitions.dart';
import '../utils/validator.dart';
import 'signup_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pushReplacement(
        smoothRoute(const MainScreen(), direction: SlideDirection.up),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Text(
                    'SummQ',
                    style: appFont(size: 46, weight: FontWeight.w800, color: AppColors.gold),
                  ),
                ),
                const SizedBox(height: 60),
                Center(
                  child: Text(
                    'Login',
                    style: appFont(size: 34, weight: FontWeight.w800, color: AppColors.gold),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Sign In to Continue',
                    style: appFont(size: 15, weight: FontWeight.w500, color: AppColors.subtitleGrey),
                  ),
                ),
                const SizedBox(height: 40),
                SummQTextField(
                  label: 'Email',
                  hint: 'email1234@gmail.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 22),
                SummQTextField(
                  label: 'Password',
                  hint: '******',
                  obscure: true,
                  controller: _passwordController,
                  validator: Validators.password, keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 34),
                SummQButton(text: 'Sign in', onTap: _submit),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      smoothRoute(const SignUpScreen(), direction: SlideDirection.right),
                    );
                  },
                  child: Text(
                    'create new account',
                    style: appFont(size: 14, weight: FontWeight.w700, color: AppColors.yellowLink),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
