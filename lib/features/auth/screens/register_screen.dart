
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  // Supabase authentication client
  final supabase = Supabase.instance.client;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  // Display messages to the user
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Register a new user with Supabase
  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmController.text;

    // Prevent repeated registration requests
    if (isLoading) return;

    // Check empty fields
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Please fill in all fields.');
      return;
    }

    // Validate email address
    final emailPattern = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailPattern.hasMatch(email)) {
      showMessage('Please enter a valid email address.');
      return;
    }

    // Validate password length
    if (password.length < 8) {
      showMessage('Password must be at least 8 characters.');
      return;
    }

    // Check matching passwords
    if (password != confirmPassword) {
      showMessage('Passwords do not match.');
      return;
    }

    // Start loading
    setState(() {
      isLoading = true;
    });

    try {
      // Create user account in Supabase
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
        },
      );

      if (!mounted) return;

      // Check registration response
      if (response.user != null) {
        // Email confirmation is enabled in Supabase.
        // The user must verify their email before logging in.
        showMessage(
          'Registration request received. '
              'Please check your email for verification.',
        );

        // Navigate to Email Verification Page (ID 8)
        AppRouter.go(context, 8);
      } else {
        showMessage(
          'Unable to complete registration. Please try again.',
        );
      }
    } on AuthException catch (error) {
      // Supabase authentication errors
      if (!mounted) return;

      showMessage(error.message);
    } catch (error) {
      // Network or unexpected errors
      if (!mounted) return;

      showMessage(
        'Something went wrong. Check your internet connection.',
      );
    } finally {
      // Stop loading
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,

      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Registration Page',
          style: AppTextStyles.body(14),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),

            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand heading
                  Text(
                    'SKINSYNC / YOUR SKIN STUDIO',
                    style: AppTextStyles.label(10),
                  ),

                  const SizedBox(height: 14),

                  // Page title
                  Text(
                    'Your routine\nbegins here.',
                    style: AppTextStyles.display(35),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Create a SkinSync account',
                    style: AppTextStyles.muted(13),
                  ),

                  const SizedBox(height: 28),

                  // Full name
                  SkinField(
                    'Full name',
                    controller: nameController,
                    hint: 'Enter your full name',
                  ),

                  const SizedBox(height: 17),

                  // Email
                  SkinField(
                    'Email',
                    controller: emailController,
                    hint: 'you@example.com',
                  ),

                  const SizedBox(height: 17),

                  // Password
                  SkinField(
                    'Password',
                    controller: passwordController,
                    obscure: hidePassword,
                    hint: 'At least 8 characters',
                  ),

                  const SizedBox(height: 17),

                  // Confirm password
                  SkinField(
                    'Confirm password',
                    controller: confirmController,
                    obscure: hidePassword,
                    hint: 'Repeat your password',
                  ),

                  const SizedBox(height: 10),

                  // Show / hide passwords
                  Row(
                    children: [
                      Checkbox(
                        value: !hidePassword,
                        activeColor: AppColors.forest,
                        onChanged: isLoading
                            ? null
                            : (value) {
                          setState(() {
                            hidePassword = !(value ?? false);
                          });
                        },
                      ),

                      Text(
                        'Show passwords',
                        style: AppTextStyles.body(12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 23),

                  // Create account button
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.forest,
                      ),
                    )
                  else
                    SkinButton(
                      'Create account',
                      onTap: register,
                    ),

                  const SizedBox(height: 15),

                  // Navigate to login
                  SkinButton(
                    'Already have an account? Log in',
                    outlined: true,
                    onTap: isLoading
                        ? null
                        : () => AppRouter.go(context, 4),
                  ),

                  const SizedBox(height: 25),

                  Center(
                    child: Text(
                      'Your skincare journey starts here.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.muted(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
