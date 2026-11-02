
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() =>
      _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  // Frequently asked questions
  final List<Map<String, String>> faqs = [
    {
      'question': 'What is SkinSync?',
      'answer':
      'SkinSync is a personal skincare companion '
          'that helps you organize routines, learn about '
          'skincare, and track your skin journey.',
    },
    {
      'question': 'How does skin analysis work?',
      'answer':
      'SkinSync is designed to support skin observations '
          'using photos and personalized information. '
          'AI analysis is still under development and '
          'should not be treated as a medical diagnosis.',
    },
    {
      'question': 'How do I update my profile?',
      'answer':
      'Open Profile, select Edit Profile, update your '
          'information, and tap Save changes.',
    },
    {
      'question': 'How do I reset my password?',
      'answer':
      'Open the Login Page and select Forgot Password. '
          'Enter your registered email to request a reset link.',
    },
    {
      'question': 'Is my personal information private?',
      'answer':
      'SkinSync uses authenticated accounts and '
          'database access controls. Additional privacy '
          'and security testing is required before release.',
    },
    {
      'question': 'Can SkinSync diagnose skin diseases?',
      'answer':
      'No. SkinSync is not a substitute for a dermatologist. '
          'If you have a serious or persistent skin concern, '
          'consult a qualified healthcare professional.',
    },
  ];

  void goTo(int screenId) {
    AppRouter.go(context, screenId);
  }

  // Reusable navigation row
  Widget supportItem(
      String title,
      String subtitle,
      IconData icon,
      int screenId,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SkinItem(
        title: title,
        detail: subtitle,
        icon: icon,
        onTap: () => goTo(screenId),
      ),
    );
  }

  // Each FAQ can expand to show its answer.
  Widget faqItem(int index) {
    final faq = faqs[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 3,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            16, 0, 16, 18,
          ),
          iconColor: AppColors.forest,
          collapsedIconColor: AppColors.forest,
          title: Text(
            faq['question']!,
            style: AppTextStyles.body(14),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                faq['answer']!,
                style: AppTextStyles.muted(13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom navigation button
  Widget navItem(
      IconData icon,
      String label,
      int screenId,
      ) {
    final isSelected = screenId == 10;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        AppRouter.go(context, screenId, replace: true);
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

  // Original five-item SkinSync navigation
  Widget buildBottomNav() {
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
            navItem(Icons.home_outlined, 'Home', 9),
            navItem(Icons.center_focus_strong, 'Analyze', 16),
            navItem(Icons.spa_outlined, 'Routine', 26),
            navItem(
              Icons.local_mall_outlined,
              'Products',
              34,
            ),
            navItem(Icons.person_outline, 'Profile', 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      bottomNavigationBar: buildBottomNav(),

      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Help & Support',
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
                Text(
                  'SKINSYNC / YOUR SKIN STUDIO',
                  style: AppTextStyles.label(10),
                ),

                const SizedBox(height: 15),

                Text(
                  'How can we\nhelp you?',
                  style: AppTextStyles.display(35),
                ),

                const SizedBox(height: 10),

                Text(
                  'Find answers and support for your '
                      'SkinSync experience.',
                  style: AppTextStyles.muted(13),
                ),

                const SizedBox(height: 28),

                // Help illustration
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.mist,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.support_agent_outlined,
                      size: 75,
                      color: AppColors.forest,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  'FREQUENTLY ASKED QUESTIONS',
                  style: AppTextStyles.label(12),
                ),

                const SizedBox(height: 16),

                // FAQ list
                ...List.generate(
                  faqs.length,
                  faqItem,
                ),

                const SizedBox(height: 26),

                Text(
                  'QUICK HELP',
                  style: AppTextStyles.label(12),
                ),

                const SizedBox(height: 16),

                supportItem(
                  'Edit your profile',
                  'Update account information',
                  Icons.person_outline,
                  11,
                ),

                supportItem(
                  'Reset your password',
                  'Recover access to your account',
                  Icons.lock_reset_outlined,
                  6,
                ),

                supportItem(
                  'Notification preferences',
                  'Manage skincare reminders',
                  Icons.notifications_outlined,
                  47,
                ),

                const SizedBox(height: 25),

                // Support contact information
                SkinCard(
                  color: AppColors.mist,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.mail_outline,
                        color: AppColors.forest,
                        size: 30,
                      ),

                      const SizedBox(height: 14),

                      Text(
                        'Need more help?',
                        style: AppTextStyles.display(24),
                      ),

                      const SizedBox(height: 9),

                      Text(
                        'Our support contact will be '
                            'available when SkinSync launches.',
                        style: AppTextStyles.muted(13),
                      ),

                      const SizedBox(height: 18),

                      SkinButton(
                        'Copy support request',
                        outlined: true,
                        onTap: () async {
                          await Clipboard.setData(
                            const ClipboardData(
                              text:
                              'Hello SkinSync Support,\n\n'
                                  'I need assistance with:\n\n'
                                  'Device:\n'
                                  'Issue:\n'
                                  'Steps to reproduce:\n',
                            ),
                          );

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Support request copied. '
                                    'Support email is not configured yet.',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Medical disclaimer
                Text(
                  'SkinSync provides skincare information '
                      'for educational purposes. It does not '
                      'replace professional medical advice, '
                      'diagnosis, or treatment.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.muted(12),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
