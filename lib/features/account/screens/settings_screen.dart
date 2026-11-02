
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final supabase = Supabase.instance.client;

  bool isLoggingOut = false;

  void goTo(int id, {bool replace = false}) {
    AppRouter.go(context, id, replace: replace);
  }

  // Show a message.
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Ask for confirmation before logging out.
  Future<void> confirmLogout() async {
    if (isLoggingOut) return;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.paper,
        title: Text(
          'Log out of SkinSync?',
          style: AppTextStyles.display(25),
        ),
        content: Text(
          'You can log in again whenever you want.',
          style: AppTextStyles.body(14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.forest),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text(
              'Log out',
              style: TextStyle(color: AppColors.forest),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await logout();
    }
  }

  // End the Supabase session on this device.
  Future<void> logout() async {
    if (isLoggingOut) return;

    setState(() {
      isLoggingOut = true;
    });

    try {
      await supabase.auth.signOut(
        scope: SignOutScope.local,
      );

      if (!mounted) return;

      // Return to the Login Page.
      goTo(4, replace: true);
    } on AuthException catch (error) {
      if (!mounted) return;
      showMessage(error.message);
    } catch (_) {
      if (!mounted) return;
      showMessage('Could not log out. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          isLoggingOut = false;
        });
      }
    }
  }

  // Reusable settings row.
  Widget settingsItem(
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
        onTap: () {
          if (!isLoggingOut) {
            goTo(screenId);
          }
        },
      ),
    );
  }

  // Individual bottom navigation button.
  Widget navItem(
      IconData icon,
      String label,
      int screenId,
      ) {
    // Settings belongs to the Profile section.
    final isSelected = screenId == 10;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (!isLoggingOut) {
          goTo(screenId, replace: true);
        }
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

  // Original SkinSync bottom navigation menu.
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
            navItem(
              Icons.center_focus_strong,
              'Analyze',
              16,
            ),
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
    final user = supabase.auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.cream,

      bottomNavigationBar: buildBottomNav(),

      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
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
                  'Settings',
                  style: AppTextStyles.display(35),
                ),

                const SizedBox(height: 8),

                Text(
                  'Your care, your preferences.',
                  style: AppTextStyles.muted(13),
                ),

                const SizedBox(height: 28),

                // Current signed-in account.
                SkinCard(
                  color: AppColors.mist,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.paper,
                        child: Icon(
                          Icons.person_outline,
                          color: AppColors.forest,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'YOUR ACCOUNT',
                              style: AppTextStyles.label(11),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              user?.email ?? 'Not signed in',
                              style: AppTextStyles.body(13),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Account settings
                Text(
                  'ACCOUNT',
                  style: AppTextStyles.label(12),
                ),

                const SizedBox(height: 15),

                settingsItem(
                  'Edit profile',
                  'Name and skin information',
                  Icons.edit_outlined,
                  11,
                ),

                settingsItem(
                  'Your skin profile',
                  'Skin type and assessment',
                  Icons.face_outlined,
                  24,
                ),

                const SizedBox(height: 20),

                // Notifications
                Text(
                  'NOTIFICATIONS',
                  style: AppTextStyles.label(12),
                ),

                const SizedBox(height: 15),

                settingsItem(
                  'Notification preferences',
                  'Manage skincare notifications',
                  Icons.notifications_outlined,
                  47,
                ),

                settingsItem(
                  'Reminder settings',
                  'Morning and evening routine times',
                  Icons.alarm_outlined,
                  46,
                ),

                const SizedBox(height: 20),

                // Help and information
                Text(
                  'SUPPORT & INFORMATION',
                  style: AppTextStyles.label(12),
                ),

                const SizedBox(height: 15),

                settingsItem(
                  'Help & Support',
                  'Questions and assistance',
                  Icons.help_outline,
                  14,
                ),

                settingsItem(
                  'About SkinSync',
                  'Learn about the application',
                  Icons.info_outline,
                  15,
                ),

                const SizedBox(height: 20),

                // Logout
                Text(
                  'ACCOUNT SESSION',
                  style: AppTextStyles.label(12),
                ),

                const SizedBox(height: 16),

                if (isLoggingOut)
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.forest,
                    ),
                  )
                else
                  SkinButton(
                    'Log out',
                    outlined: true,
                    onTap: confirmLogout,
                  ),

                const SizedBox(height: 25),

                Center(
                  child: Text(
                    'SkinSync • Your personal skincare studio',
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
