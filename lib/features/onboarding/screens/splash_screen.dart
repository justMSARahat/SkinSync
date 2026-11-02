
import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Botanical hero image
            Expanded(
              flex: 5,
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'lib/assets/images/onboarding/splash_bg.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Brand section
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.eco_outlined,
                      color: AppColors.forest,
                      size: 27,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'SkinSync',
                      style: AppTextStyles.display(44),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'SYNC YOUR ROUTINE. TRANSFORM YOUR SKIN.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.label(10).copyWith(
                        color: AppColors.plum,
                      ),
                    ),

                    const Spacer(),

                    SkinButton(
                      'Begin your skin journey',
                      onTap: () => AppRouter.go(context, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
