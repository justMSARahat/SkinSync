
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final supabase = Supabase.instance.client;

  final nameController = TextEditingController();

  String email = '';
  String selectedSkinType = 'Not selected';

  bool isLoading = true;
  bool isSaving = false;

  final List<String> skinTypes = [
    'Not selected',
    'Normal',
    'Dry',
    'Oily',
    'Combination',
    'Sensitive',
  ];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  // Show feedback to the user.
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Fetch current user information from Supabase.
  Future<void> loadProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      if (mounted) {
        showMessage('Please log in first.');
        AppRouter.go(context, 4, replace: true);
      }
      return;
    }

    try {
      final profile = await supabase
          .from('profiles')
          .select('full_name, skin_type')
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;

      final savedName =
      (profile?['full_name'] as String?)?.trim();

      final metadataName =
      user.userMetadata?['full_name'] as String?;

      final savedSkinType =
      profile?['skin_type'] as String?;

      setState(() {
        email = user.email ?? '';

        nameController.text =
        savedName != null && savedName.isNotEmpty
            ? savedName
            : (metadataName ?? '');

        selectedSkinType =
        skinTypes.contains(savedSkinType)
            ? savedSkinType!
            : 'Not selected';

        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() => isLoading = false);
      showMessage('Unable to load profile: $error');
    }
  }

  // Save name and skin type in the profiles table.
  Future<void> saveProfile() async {
    if (isSaving) return;

    final user = supabase.auth.currentUser;

    if (user == null) {
      showMessage('Your session has expired. Please log in.');
      return;
    }

    final fullName = nameController.text.trim();

    if (fullName.isEmpty) {
      showMessage('Please enter your full name.');
      return;
    }

    if (fullName.length > 100) {
      showMessage('Name must be 100 characters or fewer.');
      return;
    }

    setState(() => isSaving = true);

    try {
      // Upsert creates a row if missing, or updates
      // the existing row for this authenticated user.
      await supabase.from('profiles').upsert({
        'id': user.id,
        'full_name': fullName,
        'skin_type': selectedSkinType == 'Not selected'
            ? null
            : selectedSkinType,
      }, onConflict: 'id');

      if (!mounted) return;

      showMessage('Profile saved successfully!');

      // Open ID 10 again so it fetches updated data.
      AppRouter.go(context, 10, replace: true);
    } on PostgrestException catch (error) {
      if (!mounted) return;
      showMessage(error.message);
    } catch (error) {
      if (!mounted) return;
      showMessage('Could not save your profile. Try again.');
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  // Bottom navigation item.
  Widget navItem(
      IconData icon,
      String label,
      int screenId,
      ) {
    // Edit Profile belongs to the Profile tab.
    final isSelected = screenId == 10;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (!isSaving) {
          AppRouter.go(context, screenId, replace: true);
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

  // Original five-item SkinSync navigation.
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
            navItem(Icons.local_mall_outlined, 'Products', 34),
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
          'Edit Profile',
          style: AppTextStyles.body(14),
        ),
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: AppColors.forest,
        ),
      )
          : SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 520,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'SKINSYNC / YOUR SKIN STUDIO',
                    style: AppTextStyles.label(10),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    'Edit profile',
                    style: AppTextStyles.display(35),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Make your details feel like you.',
                    style: AppTextStyles.muted(13),
                  ),

                  const SizedBox(height: 30),

                  // Profile avatar
                  const Center(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: AppColors.mist,
                      child: Icon(
                        Icons.person_outline,
                        size: 55,
                        color: AppColors.forest,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Full name
                  SkinField(
                    'Full name',
                    controller: nameController,
                    hint: 'Enter your full name',
                  ),

                  const SizedBox(height: 20),

                  // Login email (read-only)
                  Text(
                    'Email address',
                    style: AppTextStyles.label(12),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    initialValue: email,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.mist,
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.forest,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Email changes require separate verification.',
                    style: AppTextStyles.muted(11),
                  ),

                  const SizedBox(height: 25),

                  // Skin type
                  Text(
                    'Skin type',
                    style: AppTextStyles.label(12),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    initialValue: selectedSkinType,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.paper,
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),
                    items: skinTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: isSaving
                        ? null
                        : (value) {
                      if (value != null) {
                        setState(() {
                          selectedSkinType = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Choose the skin type that best '
                        'describes your skin.',
                    style: AppTextStyles.muted(12),
                  ),

                  const SizedBox(height: 35),

                  // Save changes
                  if (isSaving)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.forest,
                      ),
                    )
                  else
                    SkinButton(
                      'Save changes',
                      onTap: saveProfile,
                    ),

                  const SizedBox(height: 15),

                  SkinButton(
                    'Cancel',
                    outlined: true,
                    onTap: () {
                      if (!isSaving) {
                        AppRouter.go(context, 10);
                      }
                    },
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
