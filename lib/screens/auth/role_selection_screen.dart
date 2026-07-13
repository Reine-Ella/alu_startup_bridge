import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  static const String routeName = '/role-selection';

  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String selectedRole = 'student';

  Future<void> register() async {
    final provider = Provider.of<AppAuthProvider>(context, listen: false);

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must contain at least 6 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await provider.registerUser(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: selectedRole,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully. Please login.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.routeName,
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Registration failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: const Color(0xFF0B1F4D),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(26),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 560),
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
                children: [
                  const Text(
                    'Join StartupBridge',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17233C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your account as a student or startup.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF777777),
                    ),
                  ),
                  const SizedBox(height: 28),

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
                    label: 'Full Name',
                    controller: nameController,
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

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
                    onSubmitted: (_) => register(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      labelText: 'Password',
                      helperText: 'Minimum 6 characters',
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
                    text: 'Create Account',
                    isLoading: authProvider.isLoading,
                    onPressed: register,
                  ),

                  const SizedBox(height: 18),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoginScreen.routeName,
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Color(0xFFFFB800),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
    final isSelected = selectedRole == value;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        setState(() {
          selectedRole = value;
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