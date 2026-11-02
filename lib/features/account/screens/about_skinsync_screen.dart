
import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

// ID 15 - About SkinSync
class AboutSkinsyncScreen extends StatelessWidget {
  const AboutSkinsyncScreen({super.key});

  // Navigate to another page
  void goTo(BuildContext context, int screenId) {
    AppRouter.go(context, screenId);
  }

  // Reusable information row
  Widget infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.muted(12),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.body(12),
          ),
        ),
      ],
    );
  }

  // Reusable feature item
  Widget featureItem(
      BuildContext context,
      String title,
      String description,
      IconData icon,
      int route,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SkinItem(
        title: title,
        detail: description,
        icon: icon,
        onTap: () => goTo(context, route),
      ),
    );
  }

  // Individual bottom navigation button
  Widget navItem(
      BuildContext context,
      IconData icon,
      String label,
      int screenId,
      ) {
    // About belongs to the Profile section
    final isSelected = screenId == 10;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        AppRouter.go(
          context,
          screenId,
          replace: true,
        );
      },
      child: SizedBox(
        width: 67,
        height: 55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? AppColors.forest
                  : AppColors.plum,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.label(10).copyWith(
                color: AppColors.forest,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Original five-item SkinSync bottom navigation
  Widget buildBottomNav(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 5, 4, 4),
        decoration: const BoxDecoration(
          color: AppColors.paper,
          border: Border(
            top: BorderSide(color: AppColors.sand),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(
              context,
              Icons.home_outlined,
              'Home',
              9,
            ),
            navItem(
              context,
              Icons.center_focus_strong,
              'Analyze',
              16,
            ),
            navItem(
              context,
              Icons.spa_outlined,
              'Routine',
              26,
            ),
            navItem(
              context,
              Icons.local_mall_outlined,
              'Products',
              34,
            ),
            navItem(
              context,
              Icons.person_outline,
              'Profile',
              10,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,

      // Keep the original navigation menu
      bottomNavigationBar: buildBottomNav(context),

      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'About SkinSync',
          style: AppTextStyles.body(14),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Small brand heading
                Text(
                  'SKINSYNC / YOUR SKIN STUDIO',
                  style: AppTextStyles.label(10),
                ),

                const SizedBox(height: 15),

                // Main heading
                Text(
                  'About SkinSync',
                  style: AppTextStyles.display(35),
                ),

                const SizedBox(height: 8),

                Text(
                  'Sync your routine. Transform your skin.',
                  style: AppTextStyles.muted(13),
                ),

                const SizedBox(height: 28),

                // Illustration - no external image required
                Container(
                  height: 230,
                  decoration: BoxDecoration(
                    color: AppColors.mist,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.spa_outlined,
                      size: 95,
                      color: AppColors.forest,
                    ),
                  ),
                ),

                const SizedBox(height: 27),

                // Introduction
                Text(
                  'Personal skincare,\nbeautifully simple.',
                  style: AppTextStyles.display(31),
                ),

                const SizedBox(height: 14),

                Text(
                  'SkinSync is a personal skincare '
                      'companion designed to help you '
                      'understand your skin, organize '
                      'daily routines, and track your '
                      'skincare journey with confidence.',
                  style: AppTextStyles.body(14),
                ),

                const SizedBox(height: 30),

                // Feature heading
                Text(
                  'EXPLORE SKINSYNC',
                  style: AppTextStyles.label(12),
                ),

                const SizedBox(height: 16),

                featureItem(
                  context,
                  'Skin assessment',
                  'Explore your personal skin profile',
                  Icons.face_retouching_natural,
                  16,
                ),

                featureItem(
                  context,
                  'Daily skincare routines',
                  'Organize morning and evening care',
                  Icons.spa_outlined,
                  26,
                ),

                featureItem(
                  context,
                  'Skin progress tracking',
                  'Document your skincare journey',
                  Icons.timeline_outlined,
                  48,
                ),

                featureItem(
                  context,
                  'Skincare education',
                  'Learn about skincare and ingredients',
                  Icons.menu_book_outlined,
                  57,
                ),

                const SizedBox(height: 25),

                // Our mission card
                SkinCard(
                  color: AppColors.mist,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        color: AppColors.forest,
                        size: 32,
                      ),

                      const SizedBox(height: 14),

                      Text(
                        'Our mission',
                        style: AppTextStyles.display(25),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Make skincare information '
                            'more accessible, personalized, '
                            'and easier to understand through '
                            'thoughtful technology.',
                        style: AppTextStyles.body(13),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // App details
                Text(
                  'APPLICATION INFORMATION',
                  style: AppTextStyles.label(12),
                ),

                const SizedBox(height: 16),

                SkinCard(
                  child: Column(
                    children: [
                      infoRow(
                        'Application',
                        'SkinSync',
                      ),

                      const Divider(
                        color: AppColors.sand,
                        height: 25,
                      ),

                      infoRow(
                        'Platform',
                        'Android / Flutter',
                      ),

                      const Divider(
                        color: AppColors.sand,
                        height: 25,
                      ),

                      infoRow(
                        'Backend',
                        'Supabase',
                      ),

                      const Divider(
                        color: AppColors.sand,
                        height: 25,
                      ),

                      infoRow(
                        'Release',
                        'Under development',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Medical disclaimer
                SkinCard(
                  color: AppColors.blush,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.health_and_safety_outlined,
                        color: AppColors.forest,
                        size: 30,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Medical disclaimer',
                        style: AppTextStyles.display(23),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'SkinSync provides skincare '
                            'information for educational '
                            'and personal tracking purposes. '
                            'It does not replace professional '
                            'medical advice, diagnosis, '
                            'or treatment.',
                        style: AppTextStyles.body(13),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'For serious or persistent skin '
                            'concerns, consult a qualified '
                            'dermatologist.',
                        style: AppTextStyles.muted(12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Help page
                SkinButton(
                  'Help & Support',
                  outlined: true,
                  onTap: () => goTo(context, 14),
                ),

                const SizedBox(height: 26),

                Center(
                  child: Text(
                    'Made with care for healthier skincare habits.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.muted(11),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
