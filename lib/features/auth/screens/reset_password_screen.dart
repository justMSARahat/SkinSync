
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  // Input controllers
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  // Supabase authentication client
  final supabase = Supabase.instance.client;

  bool hidePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  // Show message on screen
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Update password in Supabase
  Future<void> updatePassword() async {
    if (isLoading) return;

    final password = passwordController.text;
    final confirmPassword = confirmController.text;

    // Check empty fields
    if (password.isEmpty || confirmPassword.isEmpty) {
      showMessage('Please fill in both fields.');
      return;
    }

    // Check password length
    if (password.length < 8) {
      showMessage(
        'Password must contain at least 8 characters.',
      );
      return;
    }

    // Compare passwords
    if (password != confirmPassword) {
      showMessage('Passwords do not match.');
      return;
    }

    // A valid authenticated session is required.
    // The recovery link should establish this session.
    if (supabase.auth.currentSession == null) {
      showMessage(
        'Your recovery session is missing or expired. '
            'Please request a new password reset link.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Update the authenticated user's password.
      await supabase.auth.updateUser(
        UserAttributes(
          password: password,
        ),
      );

      if (!mounted) return;

      // Display success message
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Password updated'),
          content: const Text(
            'Your password has been changed successfully. '
                'Please log in with your new password.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );

      // End the recovery session
      await supabase.auth.signOut();

      if (!mounted) return;

      // Return to Login Page (ID 4)
      AppRouter.go(context, 4, replace: true);

    } on AuthException catch (error) {
      if (!mounted) return;

      showMessage(error.message);

    } catch (error) {
      if (!mounted) return;

      showMessage(
        'Unable to update password. Please try again.',
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
          'Reset Password',
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

                  const SizedBox(height: 25),

                  // Password reset illustration
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(
                        color: AppColors.mist,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset_outlined,
                        size: 72,
                        color: AppColors.forest,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Page heading
                  Text(
                    'Choose a new\npassword.',
                    style: AppTextStyles.display(35),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Keep your SkinSync experience secure.',
                    style: AppTextStyles.muted(14),
                  ),

                  const SizedBox(height: 30),

                  // New password
                  SkinField(
                    'New password',
                    controller: passwordController,
                    obscure: hidePassword,
                    hint: 'At least 8 characters',
                  ),

                  const SizedBox(height: 18),

                  // Confirm password
                  SkinField(
                    'Confirm password',
                    controller: confirmController,
                    obscure: hidePassword,
                    hint: 'Repeat your new password',
                  ),

                  const SizedBox(height: 10),

                  // Show or hide passwords
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

                  const SizedBox(height: 25),

                  // Update password button
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.forest,
                      ),
                    )
                  else
                    SkinButton(
                      'Update password',
                      onTap: updatePassword,
                    ),

                  const SizedBox(height: 15),

                  // Back to login
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
                      'Your account, securely protected.',
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
