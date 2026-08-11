import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/page_transitions.dart';
import '../utils/validator.dart';
import 'main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
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
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    'SummQ',
                    style: appFont(size: 42, weight: FontWeight.w800, color: AppColors.gold),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Create new\nAccount',
                    textAlign: TextAlign.center,
                    style: appFont(size: 30, weight: FontWeight.w800, color: AppColors.gold),
                  ),
                ),
                const SizedBox(height: 34),
                SummQTextField(
                  label: 'Name',
                  hint: 'User name',
                  controller: _nameController,
                  validator: Validators.name, keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                SummQTextField(
                  label: 'Email',
                  hint: 'email1234@gmail.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 20),
                SummQTextField(
                  label: 'Password',
                  hint: '******',
                  obscure: true,
                  controller: _passwordController,
                  validator: Validators.password, keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                SummQTextField(
                  label: 'confirm Password',
                  hint: '******',
                  obscure: true,
                  controller: _confirmController,
                  validator: Validators.confirmPassword(() => _passwordController.text), keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 30),
                SummQButton(text: 'Sign up', onTap: _submit),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
