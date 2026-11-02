
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for user input
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Supabase client
  final supabase = Supabase.instance.client;

  bool hidePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Show a message on screen
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Log in using Supabase Authentication
  Future<void> login() async {
    if (isLoading) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

    // Check empty fields
    if (email.isEmpty || password.isEmpty) {
      showMessage('Please enter your email and password.');
      return;
    }

    // Check email format
    final emailPattern = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailPattern.hasMatch(email)) {
      showMessage('Please enter a valid email address.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Ask Supabase to check the credentials
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // Only continue if Supabase created a session
      if (response.session != null &&
          response.user != null) {

        // Navigate to Home Dashboard (ID 9)
        AppRouter.go(context, 9, replace: true);

      } else {
        showMessage('Unable to log in. Please try again.');
      }

    } on AuthException catch (error) {
      if (!mounted) return;

      // Display useful authentication errors
      if (error.message.toLowerCase()
          .contains('email not confirmed')) {
        showMessage(
          'Please verify your email before logging in.',
        );
      } else {
        showMessage(error.message);
      }

    } catch (error) {
      if (!mounted) return;

      showMessage(
        'Something went wrong. Check your internet connection.',
      );

    } finally {
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
          'Login Page',
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

                  // Main heading
                  Text(
                    'Welcome\nback.',
                    style: AppTextStyles.display(35),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Your glow ritual continues.',
                    style: AppTextStyles.muted(13),
                  ),

                  const SizedBox(height: 25),

                  // Email label
                  Text(
                    'Email',
                    style: AppTextStyles.label(12),
                  ),

                  const SizedBox(height: 8),

                  // Email input
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password label
                  Text(
                    'Password',
                    style: AppTextStyles.label(12),
                  ),

                  const SizedBox(height: 8),

                  // Password input
                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.forest,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        if (!isLoading) {
                          AppRouter.go(context, 6);
                        }
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: AppColors.forest,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Login button
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.forest,
                      ),
                    )
                  else
                    SkinButton(
                      'Log in',
                      onTap: login,
                    ),

                  const SizedBox(height: 15),

                  // Create account button
                  SkinButton(
                    'Create an account',
                    outlined: true,
                    onTap: () {
                      if (!isLoading) {
                        AppRouter.go(context, 5);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      'Your personal skincare studio.',
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
