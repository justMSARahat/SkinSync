
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final supabase = Supabase.instance.client;

  bool isLoading = true;
  String? errorMessage;

  String fullName = '';
  String email = '';
  String skinType = 'Not selected';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // Load the logged-in user's profile from Supabase.
  Future<void> loadProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'Please log in to view your profile.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final profile = await supabase
          .from('profiles')
          .select('full_name, skin_type')
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;

      final savedName = profile?['full_name'] as String?;
      final metadataName =
      user.userMetadata?['full_name'] as String?;

      setState(() {
        email = user.email ?? '';

        fullName = savedName != null &&
            savedName.trim().isNotEmpty
            ? savedName
            : (metadataName != null &&
            metadataName.trim().isNotEmpty
            ? metadataName
            : 'SkinSync User');

        skinType = profile?['skin_type'] as String? ??
            'Not selected';

        isLoading = false;
      });
    } on PostgrestException catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage = error.message;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load your profile.';
        isLoading = false;
      });
    }
  }

  // Navigate to another screen.
  void goTo(int screenId, {bool replace = false}) {
    AppRouter.go(context, screenId, replace: replace);
  }

  // Reusable profile menu item.
  Widget profileItem(
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

  // One button in the bottom navigation bar.
  Widget navItem(
      IconData icon,
      String label,
      int screenId,
      ) {
    final isSelected = screenId == 10;

    return InkWell(
      onTap: () {
        if (!isSelected) {
          goTo(screenId, replace: true);
        }
      },
      borderRadius: BorderRadius.circular(12),
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
    return Scaffold(
      backgroundColor: AppColors.cream,

      // Restore the original navigation menu.
      bottomNavigationBar: buildBottomNav(),

      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Your Profile',
          style: AppTextStyles.body(14),
        ),
        actions: [
          IconButton(
            onPressed: loadProfile,
            icon: const Icon(
              Icons.refresh,
              color: AppColors.forest,
            ),
            tooltip: 'Refresh profile',
          ),
        ],
      ),

      body: SafeArea(
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: AppColors.forest,
          ),
        )
            : errorMessage != null
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.forest,
                ),

                const SizedBox(height: 16),

                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(14),
                ),

                const SizedBox(height: 20),

                SkinButton(
                  'Try again',
                  onTap: loadProfile,
                ),

                const SizedBox(height: 12),

                SkinButton(
                  'Back to login',
                  outlined: true,
                  onTap: () => goTo(
                    4,
                    replace: true,
                  ),
                ),
              ],
            ),
          ),
        )
            : RefreshIndicator(
          color: AppColors.forest,
          onRefresh: loadProfile,
          child: Center(
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(maxWidth: 520),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Brand heading
                  Text(
                    'SKINSYNC / YOUR SKIN STUDIO',
                    style: AppTextStyles.label(10),
                  ),

                  const SizedBox(height: 15),

                  // Main heading
                  Text(
                    'Your profile',
                    style: AppTextStyles.display(35),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Everything about your skincare journey.',
                    style: AppTextStyles.muted(13),
                  ),

                  const SizedBox(height: 30),

                  // Profile avatar
                  const Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.mist,
                      child: Icon(
                        Icons.person_outline,
                        size: 48,
                        color: AppColors.forest,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // User's name
                  Center(
                    child: Text(
                      fullName,
                      style: AppTextStyles.display(27),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 7),

                  // User's email
                  Center(
                    child: Text(
                      email,
                      style: AppTextStyles.muted(13),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Skin profile card
                  SkinCard(
                    color: AppColors.mist,
                    onTap: () => goTo(24),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR SKIN PROFILE',
                          style: AppTextStyles.label(11),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          skinType,
                          style: AppTextStyles.display(27),
                        ),

                        const SizedBox(height: 9),

                        Text(
                          'Tap to view your skin profile',
                          style: AppTextStyles.muted(12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 23),

                  // Account options
                  profileItem(
                    'Edit profile',
                    'Update your personal information',
                    Icons.edit_outlined,
                    11,
                  ),

                  profileItem(
                    'Settings',
                    'Privacy, security and preferences',
                    Icons.tune,
                    12,
                  ),

                  profileItem(
                    'Saved favorites',
                    'Your favorite skincare products',
                    Icons.favorite_border,
                    42,
                  ),

                  profileItem(
                    'My progress',
                    'Track your skincare journey',
                    Icons.timeline,
                    48,
                  ),

                  profileItem(
                    'Help & Support',
                    'Get assistance with SkinSync',
                    Icons.help_outline,
                    14,
                  ),

                  profileItem(
                    'About SkinSync',
                    'Learn more about the application',
                    Icons.spa_outlined,
                    15,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
