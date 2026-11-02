
import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.forest,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
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
                  Center(
                    child: Text(
                      '01 / 03',
                      style: AppTextStyles.label(15),
                    ),
                  ),

                  const SizedBox(height: 22),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(160),
                    child: const BotanicalArt(
                      height: 325,
                      assetPath:
                      'lib/assets/images/onboarding/face.jpg',
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Understand the\nskin you're in.",
                    style: AppTextStyles.display(39),
                  ),

                  const SizedBox(height: 13),

                  Text(
                    'Small observations become a routine '
                        'designed just for you.',
                    style: AppTextStyles.muted(15),
                  ),

                  const SizedBox(height: 17),

                  const SkinTag('DISCOVER'),

                  const SizedBox(height: 32),

                  SkinButton(
                    'Next',
                    onTap: () => AppRouter.go(context, 3),
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
