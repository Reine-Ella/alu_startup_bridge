import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String selectedLoginRole = 'student';
  int failedLoginAttempts = 0;

  Future<void> login() async {
    final provider = Provider.of<AppAuthProvider>(context, listen: false);

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await provider.loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      failedLoginAttempts++;

      String message = 'Please enter the correct email and password.';

      if (failedLoginAttempts >= 3) {
        message =
            'Your login details are still incorrect. Please check your credentials or create a new account.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userRole = provider.currentUserProfile?.role;

    if (userRole != selectedLoginRole) {
      await provider.logoutUser();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please choose the correct login profile for this account.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    failedLoginAttempts = 0;

    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(26),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'STARTUPBRIDGE',
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1F4D),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17233C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Login to continue as a student or startup.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF777777),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Login as',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17233C),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _roleButton(
                          title: 'Student',
                          value: 'student',
                          icon: Icons.school_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _roleButton(
                          title: 'Startup',
                          value: 'startup',
                          icon: Icons.business_center_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => login(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      labelText: 'Password',
                      filled: true,
                      fillColor: const Color(0xFFF7F7F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Login',
                    isLoading: authProvider.isLoading,
                    onPressed: login,
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RegisterScreen.routeName,
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Color(0xFFFFB800),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleButton({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final isSelected = selectedLoginRole == value;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        setState(() {
          selectedLoginRole = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0B1F4D) : const Color(0xFFF4EFEF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF17233C),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF17233C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}