
import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                      'WELCOME',
                      style: AppTextStyles.label(13),
                    ),
                  ),

                  const SizedBox(height: 27),

                  // Two botanical editorial images
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: BotanicalArt(
                          height: 320,
                          assetPath:
                          'lib/assets/images/onboarding/welcome_1.jpg',
                        ),
                      ),

                      const SizedBox(width: 11),

                      Expanded(
                        child: BotanicalArt(
                          height: 270,
                          assetPath:
                          'lib/assets/images/onboarding/welcome_2.jpg',
                          tint: AppColors.blush,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 34),

                  Text(
                    'Natural care,\nbeautifully yours.',
                    style: AppTextStyles.display(38),
                  ),

                  const SizedBox(height: 9),

                  Text(
                    'Your personal skincare studio, '
                        'thoughtfully created.',
                    style: AppTextStyles.muted(13),
                  ),

                  const SizedBox(height: 40),

                  SkinButton(
                    'Explore SkinSync',
                    onTap: () => AppRouter.go(context, 4),
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
