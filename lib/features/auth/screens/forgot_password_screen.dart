
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  final supabase = Supabase.instance.client;

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // Show a message at the bottom of the screen.
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Request a password reset email.
  Future<void> sendResetLink() async {
    if (isLoading) return;

    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage('Please enter your email address.');
      return;
    }

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
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'com.skinsync.app://login-callback/',
      );

      if (!mounted) return;

      // Don't reveal whether an email is registered.
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Check your email'),
          content: const Text(
            'If an account exists for this email address, '
                'you will receive a password reset link. '
                'Please also check your spam folder.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );

    } on AuthException catch (error) {
      if (!mounted) return;

      showMessage(error.message);

    } catch (error) {
      if (!mounted) return;

      showMessage(
        'Unable to request password reset. Please try again.',
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
          'Forgot Password',
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
                  const SizedBox(height: 35),

                  // Password recovery illustration
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(
                        color: AppColors.blush,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        size: 65,
                        color: AppColors.forest,
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  Text(
                    'A fresh start\nfor your routine.',
                    style: AppTextStyles.display(35),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Enter your email address and we'll "
                        'send you a password reset link.',
                    style: AppTextStyles.muted(14),
                  ),

                  const SizedBox(height: 30),

                  // Email input
                  SkinField(
                    'Email address',
                    controller: emailController,
                    hint: 'you@example.com',
                  ),

                  const SizedBox(height: 28),

                  // Reset request button
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.forest,
                      ),
                    )
                  else
                    SkinButton(
                      'Send reset link',
                      onTap: sendResetLink,
                    ),

                  const SizedBox(height: 15),

                  // Return to login
                  SkinButton(
                    'Back to login',
                    outlined: true,
                    onTap: () {
                      if (!isLoading) {
                        AppRouter.go(context, 4);
                      }
                    },
                  ),

                  const SizedBox(height: 25),

                  Center(
                    child: Text(
                      'A little reset, a fresh beginning.',
                      style: AppTextStyles.muted(12),
                      textAlign: TextAlign.center,
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
