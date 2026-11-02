
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends State<EmailVerificationScreen> {

  // Email entered by the user
  final emailController = TextEditingController();

  // Supabase client
  final supabase = Supabase.instance.client;

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // Show a message
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Send another verification email
  Future<void> resendEmail() async {
    final email = emailController.text.trim();

    if (isLoading) return;

    // Check email
    if (email.isEmpty) {
      showMessage('Please enter your registered email.');
      return;
    }

    // Validate email format
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
        .hasMatch(email)) {
      showMessage('Please enter a valid email address.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Resend signup confirmation email
      await supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );

      if (!mounted) return;

      showMessage(
        'Verification email requested. '
            'Please check your inbox and spam folder.',
      );

    } on AuthException catch (error) {
      if (!mounted) return;
      showMessage(error.message);

    } catch (error) {
      if (!mounted) return;
      showMessage(
        'Unable to send email. Check your connection.',
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
          'Email Verification',
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(height: 35),

                  // Verification illustration
                  Container(
                    height: 165,
                    width: 165,
                    decoration: const BoxDecoration(
                      color: AppColors.blush,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mark_email_read_outlined,
                      size: 75,
                      color: AppColors.forest,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Main heading
                  Text(
                    'Almost there!',
                    style: AppTextStyles.display(36),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'Verify your email address to begin '
                        'your SkinSync journey.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.muted(14),
                  ),

                  const SizedBox(height: 20),

                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: AppColors.mist,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.forest,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            'Open the confirmation link '
                                'sent to your email. Also '
                                'check your spam folder.',
                            style: AppTextStyles.body(12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Email field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SkinField(
                      'Registered email',
                      controller: emailController,
                      hint: 'you@example.com',
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Resend button
                  if (isLoading)
                    const CircularProgressIndicator(
                      color: AppColors.forest,
                    )
                  else
                    SkinButton(
                      'Resend verification email',
                      onTap: resendEmail,
                    ),

                  const SizedBox(height: 15),

                  // Return to login
                  SkinButton(
                    'I verified my email — Log in',
                    outlined: true,
                    onTap: () {
                      if (!isLoading) {
                        AppRouter.go(context, 4);
                      }
                    },
                  ),

                  const SizedBox(height: 25),

                  Text(
                    'Your skin journey starts with '
                        'one simple step.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.muted(12),
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
