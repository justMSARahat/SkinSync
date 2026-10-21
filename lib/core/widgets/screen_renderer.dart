import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/app_router.dart';
import '../constants/app_constants.dart';
import '../data/demo_store.dart';
import '../data/screen_catalog.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'botanical_widgets.dart';

/// Feature-specific screen renderer. Every Figma frame has its own Dart entry
/// file in lib/features and a corresponding case below. The screens share a
/// consistent botanical design language. This package is a UI prototype.
class ScreenRenderer extends StatefulWidget {
  const ScreenRenderer({super.key, required this.screenId});
  final int screenId;
  @override
  State<ScreenRenderer> createState() => _ScreenRendererState();
}

class _ScreenRendererState extends State<ScreenRenderer> {
  final store = DemoStore.instance;
  late final name = TextEditingController(text: store.name);
  late final email = TextEditingController(text: store.email);
  final password = TextEditingController();
  final field = TextEditingController();
  final search = TextEditingController();
  String choice = 'Combination';
  String period = 'Morning';
  double slider = .48;
  bool reviewed = false;
  int selectedTab = 0;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    field.dispose();
    search.dispose();
    super.dispose();
  }

  void go(int id, {bool replace = false}) =>
      AppRouter.go(context, id, replace: replace);
  void message(String t) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(t), behavior: SnackBarBehavior.floating),
  );
  Future<void> pickPhoto() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1100,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        store.setPhoto(bytes);
        if (mounted) go(20);
      }
    } catch (_) {
      if (mounted)
        message(
          'Image picker unavailable on this device. Please test on Android or iOS.',
        );
    }
  }

  Widget spacer([double h = 16]) => SizedBox(height: h);
  Widget copy(String s, {double size = 13}) =>
      Text(s, style: AppTextStyles.muted(size));
  Widget title(String s, [double size = 33]) =>
      Text(s, style: AppTextStyles.display(size));
  Widget btn(String s, int route, {bool outlined = false}) =>
      SkinButton(s, onTap: () => go(route), outlined: outlined);
  Widget section(String s, {int? link}) => SkinSectionTitle(
    s,
    action: link == null ? null : 'View all',
    onTap: link == null ? null : () => go(link),
  );
  Widget item(String s, String d, IconData icon, int id, {Widget? trailing}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SkinItem(
          title: s,
          detail: d,
          icon: icon,
          onTap: () => go(id),
          trailing: trailing,
        ),
      );
  Widget note(String s) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: SkinNotice(s),
  );
  Widget infoCard(
    String eyebrow,
    String header,
    String sub, {
    IconData icon = Icons.spa_outlined,
    Color color = AppColors.mist,
    int? target,
  }) => SkinCard(
    color: color,
    onTap: target == null ? null : () => go(target),
    padding: const EdgeInsets.all(20),
    child: SizedBox(
      height: 139,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Icon(icon, color: AppColors.sage.withOpacity(.6), size: 72),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(eyebrow.toUpperCase(), style: AppTextStyles.label(10)),
              spacer(11),
              title(header, 27),
              spacer(6),
              SizedBox(width: 235, child: copy(sub, size: 12)),
            ],
          ),
        ],
      ),
    ),
  );
  Widget badges(List<String> labels) => Wrap(
    spacing: 7,
    runSpacing: 3,
    children: labels
        .map((s) => SkinTag(s, onTap: () => message('Selected: $s')))
        .toList(),
  );
  Widget simpleList(List<(String, String, IconData, int)> data) =>
      Column(children: data.map((r) => item(r.$1, r.$2, r.$3, r.$4)).toList());
  Widget featureHeader(String name, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('SKINSYNC  /  YOUR SKIN STUDIO', style: AppTextStyles.label(10)),
      spacer(14),
      title(name, 35),
      spacer(8),
      copy(subtitle),
      spacer(25),
    ],
  );
  Widget picture({
    double height = 230,
    String? path,
    String caption = '',
    Color tint = AppColors.mist,
  }) =>
      BotanicalArt(height: height, assetPath: path, label: caption, tint: tint);
  Widget _profilePhoto() => store.selectedPhoto == null
      ? picture(
          height: 280,
          path: 'assets/images/skincare/portrait.jpg',
          caption: 'Your skin portrait',
        )
      : ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.memory(
            store.selectedPhoto!,
            height: 280,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
  Widget _editable(
    String label,
    TextEditingController c, {
    bool obscure = false,
    int lines = 1,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 19),
    child: SkinField(label, controller: c, obscure: obscure, lines: lines),
  );

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) {
      if (widget.screenId >= 62 && widget.screenId <= 75) return _admin();
      final i = widget.screenId;
      return Scaffold(
        appBar: i == 1
            ? null
            : AppBar(
                leading: i == 9
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        onPressed: () => Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : go(9, replace: true),
                      ),
                title: Text(
                  i == 9 ? 'SkinSync' : ScreenCatalog.byId(i).title,
                  overflow: TextOverflow.ellipsis,
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    tooltip: 'Browse all 83 screens',
                    onPressed: _screenBrowser,
                    icon: const Icon(Icons.grid_view_rounded, size: 22),
                  ),
                ],
              ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: ListView(
                padding: EdgeInsets.fromLTRB(24, i == 1 ? 0 : 22, 24, 38),
                children: _mobileBody(i),
              ),
            ),
          ),
        ),
        bottomNavigationBar: i >= 9 && i <= 61 ? _nav() : null,
      );
    },
  );

  Widget _nav() => SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.fromLTRB(4, 5, 4, 4),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(top: BorderSide(color: AppColors.sand)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home_outlined, 'Home', 9),
          _navIcon(Icons.center_focus_strong, 'Analyze', 16),
          _navIcon(Icons.spa_outlined, 'Routine', 26),
          _navIcon(Icons.local_mall_outlined, 'Products', 34),
          _navIcon(Icons.person_outline, 'Profile', 10),
        ],
      ),
    ),
  );
  Widget _navIcon(IconData icon, String text, int route) => InkWell(
    onTap: () => go(route, replace: true),
    child: SizedBox(
      width: 67,
      height: 55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: widget.screenId == route ? AppColors.forest : AppColors.plum,
            size: 22,
          ),
          spacer(3),
          Text(
            text,
            style: AppTextStyles.label(10).copyWith(color: AppColors.forest),
          ),
        ],
      ),
    ),
  );
  void _screenBrowser() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.paper,
      builder: (sheetContext) => SafeArea(
        child: FractionallySizedBox(
          heightFactor: .84,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(19),
                child: Text(
                  'All 83 SkinSync screens',
                  style: AppTextStyles.title(25),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: ScreenCatalog.all.length,
                  itemBuilder: (ctx, index) {
                    final e = ScreenCatalog.all[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.mist,
                        child: Text('${e.id}', style: AppTextStyles.label(12)),
                      ),
                      title: Text(e.title, style: AppTextStyles.body(13)),
                      subtitle: Text(e.module, style: AppTextStyles.muted(11)),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        go(e.id);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _mobileBody(int id) {
    switch (id) {
      case 1:
        return [
          picture(height: 490, path: 'assets/images/onboarding/splash_bg.jpg'),
          spacer(30),
          Center(child: Text('❧', style: AppTextStyles.display(45))),
          spacer(5),
          Center(child: title('SkinSync', 54)),
          spacer(10),
          Center(
            child: Text(
              'SYNC YOUR ROUTINE. TRANSFORM YOUR SKIN.',
              textAlign: TextAlign.center,
              style: AppTextStyles.label(10).copyWith(color: AppColors.plum),
            ),
          ),
          spacer(34),
          btn('Begin your skin journey', 2),
        ];
      case 2:
        return [
          Center(child: Text('01 / 03', style: AppTextStyles.label(15))),
          spacer(22),
          ClipRRect(
            borderRadius: BorderRadius.circular(160),
            child: picture(
              height: 325,
              path: 'assets/images/onboarding/face.jpg',
            ),
          ),
          spacer(30),
          title("Understand the\nskin you're in.", 39),
          spacer(13),
          copy(
            'Small observations become a routine designed just for you.',
            size: 15,
          ),
          spacer(17),
          badges(['DISCOVER']),
          spacer(32),
          btn('Next', 3),
        ];
      case 3:
        return [
          Center(child: Text('WELCOME', style: AppTextStyles.label(13))),
          spacer(27),
          Row(
            children: [
              Expanded(
                child: picture(
                  height: 320,
                  path: 'assets/images/onboarding/product.jpg',
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: picture(
                  height: 270,
                  path: 'assets/images/onboarding/botanical.jpg',
                  tint: AppColors.blush,
                ),
              ),
            ],
          ),
          spacer(34),
          title('Natural care,\nbeautifully yours.', 38),
          spacer(9),
          copy('Your personal skincare studio, thoughtfully created.'),
          spacer(40),
          btn('Explore SkinSync', 4),
        ];
      case 4:
        return [
          featureHeader('Welcome\nback.', 'Your glow ritual continues.'),
          _editable('Email', email),
          _editable('Password', password, obscure: true),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => go(6),
              child: const Text('Forgot password?'),
            ),
          ),
          spacer(27),
          SkinButton('Log in', onTap: () => _demoSignIn()),
          spacer(15),
          btn('Create an account', 5, outlined: true),
          note('Demo mode: no real password is checked or transmitted.'),
        ];
      case 5:
        return [
          featureHeader(
            'Your routine\nbegins here.',
            'Create a SkinSync account',
          ),
          _editable('Full name', name),
          _editable('Email', email),
          _editable('Password', password, obscure: true),
          badges(['Gentle care', 'Personalized']),
          spacer(23),
          SkinButton(
            'Create account',
            onTap: () {
              store.editProfile(name.text, email.text);
              go(8);
            },
          ),
          note(
            'Registration is a local UI demonstration. Connect your authentication backend before release.',
          ),
        ];
      case 6:
        return [
          spacer(35),
          picture(height: 180, caption: 'A fresh start', tint: AppColors.blush),
          spacer(34),
          featureHeader(
            'A fresh start\nfor your routine',
            "We'll send a reset link to your email.",
          ),
          _editable('Email address', email),
          SkinButton(
            'Send reset link',
            onTap: () {
              message('Demo: email service is not connected.');
              go(7);
            },
          ),
        ];
      case 7:
        return [
          spacer(25),
          picture(height: 175, tint: AppColors.mist),
          spacer(26),
          featureHeader(
            'Choose a new\npassword',
            'Keep your SkinSync experience secure.',
          ),
          _editable('New password', password, obscure: true),
          _editable('Confirm password', field, obscure: true),
          SkinButton(
            'Update password',
            onTap: () {
              if (password.text.isEmpty || password.text != field.text) {
                message('Please enter matching passwords.');
                return;
              }
              go(4);
            },
          ),
        ];
      case 8:
        return [
          spacer(35),
          picture(height: 185, tint: AppColors.blush),
          spacer(20),
          featureHeader(
            'Almost there!',
            'Enter your six-digit verification code.',
          ),
          _editable('Verification code', field),
          SkinButton('Verify', onTap: () => go(9, replace: true)),
          note('Verification is simulated in the UI prototype.'),
        ];
      case 9:
        return _home();
      case 10:
        return [
          featureHeader(
            'Your profile',
            'Everything about your skincare journey.',
          ),
          infoCard(
            'SKIN PROFILE',
            store.skinType,
            'Your unique skincare story',
            icon: Icons.face_outlined,
            color: AppColors.mist,
            target: 24,
          ),
          spacer(15),
          item('Edit profile', store.name, Icons.edit_outlined, 11),
          item(
            'Settings',
            'Reminders, privacy and preferences',
            Icons.tune,
            12,
          ),
          item(
            'Saved favorites',
            'Products you love',
            Icons.favorite_border,
            42,
          ),
          item(
            'My progress',
            'Personal diary and skin history',
            Icons.timeline,
            48,
          ),
          item('Help & Support', 'We are here to help', Icons.help_outline, 14),
          item(
            'About SkinSync',
            'Personal skincare companion',
            Icons.spa_outlined,
            15,
          ),
        ];
      case 11:
        return [
          featureHeader('Edit profile', 'Make your details feel like you.'),
          _editable('Full name', name),
          _editable('Email address', email),
          spacer(12),
          SkinButton(
            'Save changes',
            onTap: () {
              store.editProfile(name.text, email.text);
              message('Profile saved for this session.');
            },
          ),
        ];
      case 12:
        return [
          featureHeader('Settings', 'Your care, your preferences.'),
          item(
            'Notifications',
            'Get routine reminders',
            Icons.notifications_outlined,
            47,
          ),
          item(
            'Reminder settings',
            'Choose your ritual times',
            Icons.alarm_outlined,
            46,
          ),
          item(
            'Help & support',
            'Questions and feedback',
            Icons.help_outline,
            14,
          ),
          item(
            'About the app',
            'Version 1.0 UI prototype',
            Icons.info_outline,
            15,
          ),
          item('Log out', 'Back to welcome', Icons.logout, 83),
        ];
      case 13:
        return [
          featureHeader(
            'Notifications',
            'A little nudge, just when you need it.',
          ),
          item(
            'Morning ritual',
            'Remember to moisturize · 8:00 AM',
            Icons.wb_sunny_outlined,
            27,
          ),
          item(
            'Your skin check-in',
            'Time for your weekly progress picture',
            Icons.camera_alt_outlined,
            49,
          ),
          item(
            'New skincare journal',
            'Review your last observations',
            Icons.article_outlined,
            53,
          ),
        ];
      case 14:
        return [
          featureHeader('Help & support', 'How can we help you today?'),
          item(
            'How does analysis work?',
            'We only show a demo without a trained model',
            Icons.psychology_outlined,
            22,
          ),
          item(
            'Skincare safety',
            'General guidance, not a diagnosis',
            Icons.health_and_safety_outlined,
            15,
          ),
          item(
            'Notification preferences',
            'Manage alerts and reminder prompts',
            Icons.notifications_outlined,
            47,
          ),
          note(
            'For persistent or serious skin concerns, please consult a qualified dermatologist.',
          ),
        ];
      case 15:
        return [
          featureHeader(
            'About SkinSync',
            'Sync your routine. Transform your skin.',
          ),
          picture(height: 290, caption: 'Care begins with you'),
          spacer(20),
          title('Personal skincare,\nbeautifully simple.', 31),
          spacer(12),
          copy(
            'SkinSync combines daily routines, ingredient education, progress tracking and optional AI-assisted insights in one gentle experience.',
          ),
          note(AppConstants.disclaimer),
        ];
      case 16:
        return [
          featureHeader(
            'Get to know\nyour skin.',
            'A personalized assessment in a few easy steps.',
          ),
          picture(
            height: 270,
            path: 'assets/images/skincare/assessment.jpg',
            tint: AppColors.blush,
          ),
          spacer(20),
          simpleList([
            (
              'Gentle questions',
              'Tell us about how your skin feels',
              Icons.question_answer_outlined,
              17,
            ),
            (
              'Personalized profile',
              'We will save your selected skin type locally',
              Icons.face_outlined,
              24,
            ),
          ]),
          spacer(16),
          btn('Start assessment', 17),
        ];
      case 17:
        return [
          featureHeader('Your skin story', 'What best describes your skin?'),
          note(
            'Question 1 of 1 in this UI demonstration. The clinical questionnaire must be validated before release.',
          ),
          spacer(8),
          ...['Normal', 'Dry', 'Oily', 'Combination', 'Sensitive'].map(
            (x) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: SkinCard(
                color: choice == x ? AppColors.mist : AppColors.paper,
                onTap: () => setState(() => choice = x),
                child: Row(
                  children: [
                    Icon(
                      choice == x
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: AppColors.forest,
                    ),
                    const SizedBox(width: 13),
                    Text(x, style: AppTextStyles.body(15)),
                  ],
                ),
              ),
            ),
          ),
          spacer(22),
          SkinButton(
            'Save skin profile',
            onTap: () {
              store.updateSkinType(choice);
              go(18);
            },
          ),
        ];
      case 18:
        return [
          featureHeader(
            'Capture your face',
            'Use bright, even lighting and a clear face.',
          ),
          SkinCard(
            color: AppColors.forest,
            child: SizedBox(
              height: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.face_retouching_natural,
                    size: 125,
                    color: AppColors.sand,
                  ),
                  spacer(20),
                  Text(
                    'Position your face inside the guide',
                    style: AppTextStyles.body(14)
                        .copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
          spacer(21),
          SkinButton(
            'Choose a photo',
            onTap: pickPhoto,
            icon: Icons.camera_alt_outlined,
          ),
          spacer(10),
          btn('Photo tips', 19, outlined: true),
        ];
      case 19:
        return [
          featureHeader(
            'Choose your photo',
            'A clear selfie helps you document skin progress.',
          ),
          picture(height: 290, caption: 'Your photo, your progress.'),
          spacer(22),
          SkinButton(
            'Open photo gallery',
            onTap: pickPhoto,
            icon: Icons.photo_library_outlined,
          ),
          spacer(14),
          btn('Tips for a great photo', 20, outlined: true),
          note(
            'Photos are kept in memory for this prototype; no image is uploaded to a server.',
          ),
        ];
      case 20:
        return [
          featureHeader(
            'Ready to analyze?',
            'Check the photo before continuing.',
          ),
          _profilePhoto(),
          spacer(18),
          ...['Even lighting', 'Face clearly visible', 'No beauty filters'].map(
            (x) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: AppColors.sage),
                  const SizedBox(width: 10),
                  copy(x),
                ],
              ),
            ),
          ),
          spacer(20),
          btn('Continue to analysis', 21),
          spacer(10),
          SkinButton('Choose another photo', onTap: pickPhoto, outlined: true),
        ];
      case 21:
        return [
          spacer(55),
          picture(height: 250, caption: 'A mindful moment'),
          spacer(33),
          title('Your skin insights', 31),
          spacer(10),
          copy(
            'Real image analysis requires a validated model and backend integration.',
          ),
          spacer(20),
          const LinearProgressIndicator(
            value: .6,
            color: AppColors.forest,
            backgroundColor: AppColors.sand,
          ),
          spacer(22),
          SkinButton('View sample report', onTap: () => go(22)),
          note(
            'The next screen displays sample information, not predictions from your photograph.',
          ),
        ];
      case 22:
        return [
          featureHeader(
            'Your skin\ninsights',
            'An illustrative skincare snapshot.',
          ),
          infoCard(
            'SAMPLE • NOT AI OUTPUT',
            '78 / 100',
            'Example overall score',
            icon: Icons.spa_outlined,
          ),
          spacer(17),
          simpleList([
            (
              'Hydration',
              'Illustrative score · balanced',
              Icons.water_drop_outlined,
              23,
            ),
            (
              'Texture',
              'Illustrative score · mild',
              Icons.blur_on_outlined,
              23,
            ),
            (
              'Visible redness',
              'Illustrative score · low',
              Icons.favorite_border,
              23,
            ),
          ]),
          note(
            'These numbers are placeholders. The app cannot diagnose skin conditions.',
          ),
          spacer(12),
          btn('View your skin profile', 24),
        ];
      case 23:
        return [
          featureHeader(
            'Skin concerns',
            'Understand visible changes with care.',
          ),
          picture(height: 220, tint: AppColors.blush),
          spacer(20),
          simpleList([
            (
              'Skin texture',
              'General educational information',
              Icons.grain,
              40,
            ),
            (
              'Dark spots',
              'Learn about uneven tone',
              Icons.brightness_medium,
              40,
            ),
            (
              'Redness',
              'Learn about skin sensitivity',
              Icons.favorite_border,
              40,
            ),
          ]),
          note('A professional diagnosis requires a qualified clinician.'),
        ];
      case 24:
        return [
          featureHeader('Your skin profile', 'Made personal, kept simple.'),
          infoCard(
            'YOUR SKIN TYPE',
            store.skinType,
            'Chosen from your questionnaire',
            icon: Icons.face_outlined,
          ),
          spacer(15),
          item('Skin concerns', store.skinConcern, Icons.spa_outlined, 23),
          item(
            'Change assessment',
            'Retake the skin questionnaire',
            Icons.edit_note,
            17,
          ),
          item(
            'Analysis history',
            'View previous demo entries',
            Icons.history,
            25,
          ),
        ];
      case 25:
        return [
          featureHeader('Analysis history', 'A thoughtful record of change.'),
          ...['18 Oct 2026', '04 Oct 2026', '20 Sep 2026'].map(
            (s) => item(
              s,
              'Example observation — not an AI result',
              Icons.history_toggle_off,
              22,
            ),
          ),
        ];
      case 26:
        return _routineDashboard();
      case 27:
        return _routineSteps(false);
      case 28:
        return _routineSteps(true);
      case 29:
        return [
          featureHeader('Routine details', 'Every small step has a purpose.'),
          infoCard(
            'EVERYDAY BASICS',
            'Gentle & consistent',
            'Cleanse · Hydrate · Protect',
          ),
          spacer(18),
          item(
            'The cleanser',
            'Wash away impurities without stripping',
            Icons.water_drop_outlined,
            30,
          ),
          item(
            'The moisturizer',
            'Help support your skin barrier',
            Icons.spa_outlined,
            30,
          ),
          item(
            'The sunscreen',
            'Daily sun protection',
            Icons.wb_sunny_outlined,
            30,
          ),
          btn('Customize my routine', 33),
        ];
      case 30:
        return [
          featureHeader('The art of care', 'A closer look at your next step.'),
          picture(
            height: 275,
            path: 'assets/images/products/moisturizer.jpg',
            tint: AppColors.blush,
          ),
          spacer(20),
          title('Moisturize with intention', 27),
          spacer(9),
          copy(
            'After cleansing, apply a gentle moisturizer appropriate for your skin. Introduce new products gradually.',
          ),
          spacer(19),
          btn('See suggested products', 41),
        ];
      case 31:
        return [
          spacer(36),
          picture(height: 290, caption: 'Ritual complete ❧'),
          spacer(22),
          title('Beautifully done.', 35),
          spacer(10),
          copy(
            'Consistency is the real glow. Take pride in showing up for your skin.',
          ),
          spacer(29),
          btn('Back to routines', 26),
        ];
      case 32:
        return [
          featureHeader(
            'Your routine calendar',
            'A gentle rhythm, one day at a time.',
          ),
          SkinCard(
            child: Column(
              children: [
                Text('OCTOBER 2026', style: AppTextStyles.label(13)),
                spacer(18),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 35,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 7,
                    crossAxisSpacing: 7,
                  ),
                  itemBuilder: (c, i) => Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i % 5 == 0 ? AppColors.mist : AppColors.paper,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      i < 31 ? '${i + 1}' : '',
                      style: AppTextStyles.label(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          spacer(16),
          note(
            'Calendar highlights are sample UI entries. Real streaks need persisted completion records.',
          ),
          btn('Your routine', 26),
        ];
      case 33:
        return [
          featureHeader('Make it yours', 'A routine that fits your life.'),
          item(
            'Morning ritual',
            'Cleanser · Moisturizer · SPF',
            Icons.wb_sunny_outlined,
            27,
          ),
          item(
            'Evening ritual',
            'Cleanser · Serum · Moisturizer',
            Icons.nights_stay_outlined,
            28,
          ),
          item(
            'Gentle product guide',
            'Explore suitable categories',
            Icons.spa_outlined,
            41,
          ),
          SkinButton(
            'Save routine preferences',
            onTap: () => message('Preferences saved for this session.'),
          ),
        ];
      case 34:
        return _products();
      case 35:
        return [
          featureHeader(
            'Discover products',
            'Search our sample product collection.',
          ),
          SkinField(
            'Product name',
            controller: search,
            hint: 'e.g. moisturizer',
          ),
          spacer(14),
          SkinButton('Search products', onTap: () => setState(() {})),
          spacer(15),
          ..._productList(filtered: search.text),
        ];
      case 36:
        return [
          featureHeader('Shop by category', 'Simplify your skincare shelf.'),
          ...[
            'Cleansers',
            'Toners',
            'Serums',
            'Moisturizers',
            'Sunscreens',
            'Face masks',
          ].map(
            (s) =>
                item(s, 'Explore skincare essentials', Icons.spa_outlined, 35),
          ),
        ];
      case 37:
        return [
          featureHeader('Product details', 'A closer look at everyday care.'),
          picture(
            height: 260,
            path: 'assets/images/products/moisturizer.jpg',
            caption: 'Centella Soothing Cream',
          ),
          spacer(16),
          title('Centella Soothing Cream', 27),
          spacer(6),
          copy('Hydrating moisturizer · Example product'),
          spacer(14),
          badges(['Hydrating', 'Skin barrier', 'Gentle']),
          spacer(19),
          SkinButton(
            store.favorites.contains('Centella Soothing Cream')
                ? 'Remove favorite'
                : 'Save to favorites',
            icon: store.favorites.contains('Centella Soothing Cream')
                ? Icons.favorite
                : Icons.favorite_border,
            onTap: () => store.toggleFavorite('Centella Soothing Cream'),
          ),
          spacer(12),
          btn('Read ingredients', 38, outlined: true),
          note('Product suitability varies. Patch test when appropriate.'),
        ];
      case 38:
        return [
          featureHeader(
            'What is inside?',
            'An educational ingredient overview.',
          ),
          item(
            'Centella asiatica',
            'Commonly used for soothing skincare',
            Icons.eco_outlined,
            40,
          ),
          item(
            'Glycerin',
            'Humectant that helps retain moisture',
            Icons.water_drop_outlined,
            40,
          ),
          item(
            'Niacinamide',
            'Common skincare ingredient',
            Icons.science_outlined,
            40,
          ),
        ];
      case 39:
        return [
          featureHeader(
            'Ingredient search',
            'Understand what is inside your skincare.',
          ),
          SkinField(
            'Search ingredient',
            controller: search,
            hint: 'e.g. niacinamide',
          ),
          spacer(17),
          ..._ingredientItems(search.text),
        ];
      case 40:
        return [
          featureHeader('Ingredient guide', 'The basics behind your bottle.'),
          infoCard(
            'SPOTLIGHT',
            'Niacinamide',
            'Used in skincare for barrier support',
            icon: Icons.science_outlined,
          ),
          spacer(16),
          item(
            'Benefits',
            'Supports hydration and skin barrier',
            Icons.check_circle_outline,
            38,
          ),
          item(
            'Usage notes',
            'Introduce gradually and monitor irritation',
            Icons.info_outline,
            38,
          ),
          note(
            'Educational only. Check formulations and seek clinical advice when needed.',
          ),
        ];
      case 41:
        return [
          featureHeader(
            'Selected for you',
            'An example product collection for ${store.skinType.toLowerCase()} skin.',
          ),
          ..._productList(),
          btn('Search all products', 35),
        ];
      case 42:
        return [
          featureHeader('Your favorites', 'Keep your care close.'),
          if (store.favorites.isEmpty)
            infoCard(
              'SAVED ITEMS',
              'Nothing saved yet',
              'Browse products to get started',
              target: 34,
            ),
          ...store.favorites.map(
            (s) => item(s, 'Tap to view product', Icons.favorite, 37),
          ),
        ];
      case 43:
        return [
          featureHeader('Your gentle reminders', 'Make a moment for yourself.'),
          ...store.reminders.map(
            (r) => item(
              r,
              'Tap to edit routine reminder',
              Icons.alarm_outlined,
              45,
            ),
          ),
          spacer(11),
          btn('Create reminder', 44),
          spacer(10),
          btn('Reminder settings', 46, outlined: true),
        ];
      case 44:
        return [
          featureHeader(
            'A moment to remember',
            'Create a new personal reminder.',
          ),
          _editable('Reminder name and time', field),
          SkinButton(
            'Save reminder',
            onTap: () {
              store.addReminder(field.text);
              message('Reminder saved locally, without OS notifications.');
              go(43);
            },
          ),
        ];
      case 45:
        return [
          featureHeader('Edit reminder', 'Adjust your daily ritual schedule.'),
          ...store.reminders.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SkinCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    copy(entry.value),
                    spacer(9),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            store.editReminder(
                              entry.key,
                              'Updated ritual · 7:30 AM',
                            );
                            message('Reminder updated locally.');
                          },
                          child: const Text('Change time'),
                        ),
                        TextButton(
                          onPressed: () => store.removeReminder(entry.key),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      case 46:
        return [
          featureHeader('Reminder settings', 'Build routines you can keep.'),
          _toggle('Morning reminders', store.morningReminder, store.setMorning),
          _toggle('Evening reminders', store.eveningReminder, store.setEvening),
          item(
            'Edit reminder times',
            'Choose your own schedule',
            Icons.schedule,
            45,
          ),
          note('Native scheduled notifications are not yet implemented.'),
        ];
      case 47:
        return [
          featureHeader(
            'Notification preferences',
            'Just the right amount of support.',
          ),
          _toggle('Skincare tips', store.tips, store.setTips),
          _toggle(
            'Product & feature news',
            store.newsletters,
            store.setNewsletters,
          ),
          item(
            'Daily routine times',
            'Morning and evening settings',
            Icons.schedule,
            46,
          ),
        ];
      case 48:
        return [
          featureHeader(
            'Your skin journey',
            'Little changes deserve remembering.',
          ),
          infoCard(
            'SKIN JOURNEY',
            'Week 04',
            'Stay consistent with your care',
            icon: Icons.timeline,
          ),
          spacer(19),
          item(
            'Upload progress photo',
            'Save a new photo during this session',
            Icons.add_a_photo_outlined,
            49,
          ),
          item(
            'Progress gallery',
            'View photo preview',
            Icons.collections_outlined,
            50,
          ),
          item(
            'Compare before & after',
            'Explore visual changes',
            Icons.compare_outlined,
            51,
          ),
          item(
            'Progress timeline',
            'Your skincare journey over time',
            Icons.timeline_outlined,
            52,
          ),
          item(
            'Skincare journal',
            'Record your daily observations',
            Icons.menu_book_outlined,
            53,
          ),
        ];
      case 49:
        return [
          featureHeader(
            'Capture your progress',
            'Consistent photos tell a clearer story.',
          ),
          picture(height: 275, caption: 'Another step forward'),
          spacer(20),
          SkinButton(
            'Select progress photo',
            onTap: pickPhoto,
            icon: Icons.add_a_photo_outlined,
          ),
          note(
            'The prototype holds one photo in memory. Cloud storage and privacy controls must be integrated separately.',
          ),
        ];
      case 50:
        return [
          featureHeader('Progress gallery', 'Your personal skin reflections.'),
          _profilePhoto(),
          spacer(17),
          btn('Compare photos', 51),
          spacer(10),
          btn('Add new photo', 49, outlined: true),
        ];
      case 51:
        return [
          featureHeader('Before & after', 'Two moments, one personal journey.'),
          _profilePhoto(),
          spacer(20),
          Text('Comparison position', style: AppTextStyles.label(12)),
          Slider(
            value: slider,
            min: 0,
            max: 1,
            onChanged: (v) => setState(() => slider = v),
          ),
          copy(
            'Drag to explore the comparison concept. A second dated photo is needed for a real comparison.',
          ),
          spacer(15),
          btn('Progress gallery', 50),
        ];
      case 52:
        return [
          featureHeader(
            'Progress timeline',
            'Look back on the little victories.',
          ),
          ...['Week 04 · Current', 'Week 03', 'Week 02', 'Week 01'].map(
            (s) => item(s, 'Illustrative progress entry', Icons.timeline, 50),
          ),
          btn('Add your observation', 54),
        ];
      case 53:
        return [
          featureHeader(
            'Your skincare journal',
            'Remember how your skin feels.',
          ),
          ...store.journal.map(
            (x) => item('Journal note', x, Icons.book_outlined, 55),
          ),
          spacer(16),
          btn('New journal entry', 54),
        ];
      case 54:
        return [
          featureHeader(
            'Write your reflection',
            'How does your skin feel today?',
          ),
          SkinField(
            'Your journal entry',
            controller: field,
            lines: 5,
            hint: 'Today my skin feels...',
          ),
          spacer(22),
          SkinButton(
            'Save reflection',
            onTap: () {
              store.addJournal(field.text);
              go(53);
            },
          ),
        ];
      case 55:
        return [
          featureHeader(
            'Journal entry',
            'A moment from your skincare journey.',
          ),
          infoCard(
            'PERSONAL OBSERVATION',
            'Your reflections',
            store.journal.isEmpty ? 'No entry yet' : store.journal.first,
            icon: Icons.menu_book_outlined,
          ),
          spacer(20),
          btn('Back to journal', 53),
        ];
      case 56:
        return [
          featureHeader(
            'Skincare history',
            'Reflect on your changing routine.',
          ),
          item(
            'Routine records',
            'Explore your past habits',
            Icons.today_outlined,
            32,
          ),
          item(
            'Photo timeline',
            'Compare visual progress',
            Icons.photo_library_outlined,
            52,
          ),
          item(
            'Journal entries',
            'Read your observations',
            Icons.book_outlined,
            53,
          ),
        ];
      case 57:
        return [
          featureHeader('Skincare library', 'Knowledge for a gentler routine.'),
          picture(
            height: 230,
            path: 'assets/images/skincare/articles.jpg',
            caption: 'Learn, then glow',
          ),
          spacer(21),
          item(
            'Explore categories',
            'Sun care, cleansing, hydration',
            Icons.menu_book_outlined,
            58,
          ),
          item(
            'Read all articles',
            'Everyday skincare essentials',
            Icons.article_outlined,
            59,
          ),
          item(
            'Your saved articles',
            'Revisit favorite lessons',
            Icons.bookmark_border,
            61,
          ),
        ];
      case 58:
        return [
          featureHeader(
            'Article categories',
            'Explore what matters to your skin.',
          ),
          ...[
            'Your skin barrier',
            'Cleansing',
            'Moisturizing',
            'Sun protection',
            'Ingredients',
            'Gentle routines',
          ].map(
            (s) => item(
              s,
              'Helpful educational reads',
              Icons.article_outlined,
              59,
            ),
          ),
        ];
      case 59:
        return [
          featureHeader(
            'Skincare articles',
            'Practical care, clearly explained.',
          ),
          item(
            'Understanding Your Skin Barrier',
            'A gentle introduction · 4 min',
            Icons.spa_outlined,
            60,
          ),
          item(
            'Why Sunscreen Matters',
            'Everyday UV protection · 5 min',
            Icons.wb_sunny_outlined,
            60,
          ),
          item(
            'Creating a Morning Ritual',
            'Simple daily consistency · 3 min',
            Icons.wb_twilight_outlined,
            60,
          ),
        ];
      case 60:
        return [
          featureHeader(
            'Understanding Your\nSkin Barrier',
            'SKINCARE ESSENTIALS  ·  4 MIN READ',
          ),
          picture(height: 220, path: 'assets/images/skincare/articles.jpg'),
          spacer(22),
          title('A gentle foundation', 26),
          spacer(12),
          copy(
            'Your skin barrier helps retain moisture and limit environmental irritation. Gentle cleansing, adequate moisturizing and protection can support comfortable skin.',
            size: 14,
          ),
          spacer(18),
          copy(
            'Skincare needs are individual. Consult a dermatologist for ongoing irritation, persistent acne or other concerns.',
          ),
          spacer(18),
          SkinButton(
            store.savedArticles.contains('Understanding Your Skin Barrier')
                ? 'Remove from saved'
                : 'Save this article',
            onTap: () => store.toggleArticle('Understanding Your Skin Barrier'),
            icon: Icons.bookmark_border,
          ),
        ];
      case 61:
        return [
          featureHeader('Saved articles', 'Your personal reading shelf.'),
          if (store.savedArticles.isEmpty)
            infoCard(
              'LIBRARY',
              'Nothing saved',
              'Explore an article to save it',
              target: 59,
            ),
          ...store.savedArticles.map(
            (s) => item(s, 'Tap to continue reading', Icons.bookmark, 60),
          ),
        ];
      case 76:
        return [
          spacer(100),
          Center(
            child: const CircularProgressIndicator(color: AppColors.forest),
          ),
          spacer(27),
          Center(child: title('Finding your calm...', 28)),
          spacer(8),
          Center(child: copy('Loading your skincare studio')),
          spacer(38),
          btn('Return home', 9),
        ];
      case 77:
        return _systemState(
          Icons.wifi_off,
          'You seem offline',
          'Check your internet connection and try again.',
          9,
        );
      case 78:
        return _systemState(
          Icons.inbox_outlined,
          'Nothing here yet',
          'Your skin journey is just beginning.',
          9,
        );
      case 79:
        return _systemState(
          Icons.error_outline,
          'A little hiccup',
          'Something unexpected happened. Please try again.',
          9,
        );
      case 80:
        return _systemState(
          Icons.lock_outline,
          'Private space',
          'You do not have permission to view this page.',
          9,
        );
      case 81:
        return _systemState(
          Icons.search_off,
          'Page not found',
          'That page might have moved or never existed.',
          9,
        );
      case 82:
        return [
          featureHeader('Delete this item?', 'A confirmation dialog concept.'),
          SkinCard(
            child: Column(
              children: [
                const Icon(
                  Icons.delete_outline,
                  size: 65,
                  color: AppColors.forest,
                ),
                spacer(14),
                title('Are you sure?', 25),
                spacer(12),
                copy('This action cannot be undone.'),
                spacer(28),
                SkinButton(
                  'Delete item',
                  onTap: () => message('Demo delete action confirmed.'),
                ),
                spacer(12),
                btn('Cancel', 9, outlined: true),
              ],
            ),
          ),
        ];
      case 83:
        return [
          featureHeader(
            'Log out of SkinSync?',
            'Come back whenever you need care.',
          ),
          SkinCard(
            child: Column(
              children: [
                const Icon(Icons.logout, size: 65, color: AppColors.forest),
                spacer(15),
                title('See you soon.', 28),
                spacer(25),
                SkinButton('Log out', onTap: () => go(4, replace: true)),
                spacer(12),
                btn('Stay here', 10, outlined: true),
              ],
            ),
          ),
        ];
      default:
        return _systemState(
          Icons.search_off,
          'Page not found',
          'This screen is not in the catalog.',
          9,
        );
    }
  }

  void _demoSignIn() {
    if (email.text.trim().isEmpty) {
      message('Please enter an email to continue in demo mode.');
      return;
    }
    store.editProfile(name.text, email.text);
    go(9, replace: true);
  }

  List<Widget> _home() => [
    Padding(
      padding: const EdgeInsets.only(top: 6),
      child: copy('Good morning,', size: 13),
    ),
    title('${store.name}   ❧', 31),
    spacer(19),
    Stack(
      children: [
        picture(height: 237, path: 'assets/images/skincare/botanical.jpg'),
        Positioned(
          left: 13,
          bottom: 17,
          child: Container(
            width: 230,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.forest.withOpacity(.94),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              'Healthy skin\nis a journey,\nnot a destination.',
              style: AppTextStyles.title(21).copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
    spacer(19),
    section('Your skin today'),
    spacer(5),
    Row(
      children: [
        const SkinStat('SKIN SCORE', '78'),
        const SizedBox(width: 10),
        Expanded(
          child: SkinCard(
            color: AppColors.mist,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MORNING RITUAL', style: AppTextStyles.label(10)),
                spacer(9),
                title('${store.completed.length} of 5', 27),
                spacer(6),
                LinearProgressIndicator(
                  value: (store.completed.length / 5).clamp(0.0, 1.0),
                  backgroundColor: AppColors.sand,
                  color: AppColors.forest,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    spacer(23),
    section('Explore your care'),
    spacer(10),
    Row(
      children: [
        _quickTile(Icons.spa_outlined, 'My Routine', 26),
        const SizedBox(width: 9),
        _quickTile(Icons.center_focus_strong, 'AI Analysis', 16, dark: true),
        const SizedBox(width: 9),
        _quickTile(Icons.local_mall_outlined, 'Products', 34),
      ],
    ),
    spacer(20),
    item(
      'Education & tips',
      'Discover gentle skincare guidance',
      Icons.menu_book_outlined,
      57,
    ),
    item(
      'Your progress',
      'Keep track of the little things',
      Icons.timeline,
      48,
    ),
    note('Skin score and analysis values are illustrative, not measurements.'),
  ];
  Widget _quickTile(
    IconData icon,
    String label,
    int route, {
    bool dark = false,
  }) => Expanded(
    child: SkinCard(
      color: dark ? AppColors.forest : AppColors.paper,
      onTap: () => go(route),
      padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 5),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: dark ? AppColors.white : AppColors.forest,
          ),
          spacer(14),
          Text(
            label,
            style: AppTextStyles.label(11)
                .copyWith(color: dark ? AppColors.white : AppColors.forest),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
  List<Widget> _routineDashboard() => [
    featureHeader('Your daily ritual', 'Find a gentle moment for yourself.'),
    infoCard(
      'MORNING / EVENING',
      'A simpler ritual',
      'Support your skin every day',
      icon: Icons.spa_outlined,
    ),
    spacer(15),
    item(
      'Morning routine',
      'Five little moments of care',
      Icons.wb_sunny_outlined,
      27,
    ),
    item(
      'Evening routine',
      'Time to unwind and restore',
      Icons.nights_stay_outlined,
      28,
    ),
    item(
      'Routine calendar',
      'View your consistency',
      Icons.calendar_month_outlined,
      32,
    ),
    item('Customize routine', 'Adapt to your preferences', Icons.tune, 33),
  ];
  List<Widget> _routineSteps(bool evening) {
    final steps = evening
        ? [
            'Cleanser',
            'Hydrating toner',
            'Treatment serum',
            'Moisturizer',
            'Lip balm',
          ]
        : ['Cleanser', 'Toner', 'Serum', 'Moisturizer', 'Sunscreen'];
    return [
      featureHeader(
        evening ? 'Evening ritual' : 'Morning ritual',
        evening
            ? 'Gentle care before you rest.'
            : 'A peaceful beginning to your day.',
      ),
      infoCard(
        evening ? 'NIGHT CARE' : 'DAY CARE',
        '${store.completed.length} / 5 complete',
        'Mark each step when you finish',
        icon: evening ? Icons.nightlight_outlined : Icons.sunny,
      ),
      spacer(15),
      ...steps.map(
        (s) => Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: SkinItem(
            title: s,
            detail: store.completed.contains(s)
                ? 'Completed • well done'
                : 'Tap the checkbox to mark complete',
            icon: Icons.spa_outlined,
            onTap: () => go(30),
            trailing: Checkbox(
              value: store.completed.contains(s),
              onChanged: (_) => store.toggleCompleted(s),
              activeColor: AppColors.forest,
            ),
          ),
        ),
      ),
      spacer(12),
      btn('Finish this ritual', 31),
      spacer(8),
      btn('Learn about each step', 29, outlined: true),
    ];
  }

  List<Widget> _productList({String filtered = ''}) {
    final products = [
      ('Centella Soothing Cream', 'Moisturizer · gentle hydration'),
      ('Green Tea Gel Cleanser', 'Cleanser · daily comfort'),
      ('Daily Mineral SPF', 'Sunscreen · day protection'),
      ('Niacinamide Serum', 'Serum · balanced routine'),
    ];
    final visible = products.where(
      (x) => x.$1.toLowerCase().contains(filtered.trim().toLowerCase()),
    );
    return [
      ...visible.map((p) => item(p.$1, p.$2, Icons.local_mall_outlined, 37)),
      if (visible.isEmpty)
        infoCard('SEARCH', 'No matches yet', 'Try a different skincare term'),
    ];
  }

  List<Widget> _products() => [
    featureHeader(
      'Discover skincare',
      'Thoughtfully chosen, simply explained.',
    ),
    picture(
      height: 210,
      path: 'assets/images/products/editorial.jpg',
      caption: 'Daily essentials',
    ),
    spacer(21),
    item(
      'Search products',
      'Explore a curated demo collection',
      Icons.search,
      35,
    ),
    item(
      'Product categories',
      'Browse by everyday needs',
      Icons.category_outlined,
      36,
    ),
    item(
      'Recommended for you',
      'A personal collection',
      Icons.spa_outlined,
      41,
    ),
    item('Saved favorites', 'Your skincare shelf', Icons.favorite_outline, 42),
    spacer(15),
    section('Featured essentials'),
    spacer(9),
    ..._productList(),
  ];
  List<Widget> _ingredientItems(String f) {
    final ss = [
      'Niacinamide',
      'Glycerin',
      'Centella asiatica',
      'Hyaluronic acid',
      'Salicylic acid',
    ];
    return [
      for (final s in ss.where(
        (s) => s.toLowerCase().contains(f.trim().toLowerCase()),
      ))
        item(
          s,
          'Benefits, precautions and usage notes',
          Icons.science_outlined,
          40,
        ),
    ];
  }

  Widget _toggle(String label, bool v, ValueChanged<bool> changed) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: SkinCard(
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label, style: AppTextStyles.body(14)),
        value: v,
        activeColor: AppColors.forest,
        onChanged: changed,
      ),
    ),
  );
  List<Widget> _systemState(
    IconData icon,
    String header,
    String detail,
    int target,
  ) => [
    spacer(85),
    SkinCard(
      color: AppColors.mist,
      child: SizedBox(
        height: 190,
        child: Center(child: Icon(icon, size: 91, color: AppColors.forest)),
      ),
    ),
    spacer(26),
    Center(child: title(header, 31)),
    spacer(13),
    Center(
      child: Text(
        detail,
        style: AppTextStyles.muted(14),
        textAlign: TextAlign.center,
      ),
    ),
    spacer(29),
    btn('Return to SkinSync', target),
  ];

  Widget _admin() {
    final id = widget.screenId;
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (c, sz) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: sz.maxWidth < 1050 ? 1050 : sz.maxWidth,
              height: sz.maxHeight,
              child: Row(
                children: [
                  Container(
                    width: 245,
                    color: AppColors.forest,
                    child: _adminSidebar(),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(38),
                      children: _adminBody(id),
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

  Widget _adminSidebar() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 30, 14, 8),
        child: Text(
          '❧ SkinSync',
          style: AppTextStyles.title(30).copyWith(color: Colors.white),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(28, 0, 10, 25),
        child: Text(
          'SKIN-HEALTH STUDIO',
          style: AppTextStyles.label(10).copyWith(color: AppColors.sand),
        ),
      ),
      ...[
        ('Dashboard', 63, Icons.dashboard_outlined),
        ('Users', 64, Icons.people_outline),
        ('Products', 66, Icons.local_mall_outlined),
        ('Ingredients', 68, Icons.science_outlined),
        ('Routines', 70, Icons.spa_outlined),
        ('Articles', 72, Icons.article_outlined),
        ('AI Monitoring', 74, Icons.analytics_outlined),
        ('Settings', 75, Icons.settings_outlined),
      ].map(
        (e) => ListTile(
          leading: Icon(e.$3, color: AppColors.sand),
          title: Text(
            e.$1,
            style: AppTextStyles.body(13).copyWith(color: AppColors.paper),
          ),
          onTap: () => go(e.$2),
        ),
      ),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          'Educational prototype • No real patient data',
          style: AppTextStyles.muted(10).copyWith(color: AppColors.sand),
        ),
      ),
    ],
  );
  List<Widget> _adminBody(int id) {
    final common = [
      Text(ScreenCatalog.byId(id).title, style: AppTextStyles.display(37)),
      spacer(8),
      copy('A calm, informed view of your SkinSync workspace.'),
      spacer(26),
    ];
    switch (id) {
      case 62:
        return [
          spacer(80),
          title('Welcome back.', 44),
          spacer(10),
          copy('Manage skincare content and insights in a private workspace.'),
          spacer(35),
          SizedBox(width: 490, child: _editable('Admin email', email)),
          SizedBox(
            width: 490,
            child: _editable('Password', password, obscure: true),
          ),
          SizedBox(
            width: 490,
            child: SkinButton('Open admin demo', onTap: () => go(63)),
          ),
          note(
            'This admin login is UI-only. There is no role verification or secure administrative API.',
          ),
        ];
      case 63:
        return [
          ...common,
          Row(
            children: [
              const SkinStat('COMMUNITY MEMBERS', '1,284'),
              const SizedBox(width: 15),
              const SkinStat('SKIN CHECK-INS', '368'),
              const SizedBox(width: 15),
              const SkinStat('PRODUCTS', '128'),
            ],
          ),
          spacer(30),
          infoCard(
            'COMMUNITY INSIGHTS',
            'The SkinSync studio',
            'All values shown are illustrative admin demo data',
          ),
          spacer(20),
          item(
            'Manage products',
            'Curate the demo skincare catalog',
            Icons.local_mall_outlined,
            66,
          ),
          item(
            'Manage educational content',
            'Review articles and guidance',
            Icons.book_outlined,
            72,
          ),
        ];
      case 64:
        return [
          ...common,
          _adminToolbar('Search users', 65),
          _adminRows('User', 'Active user', 'Status', 65, 8),
        ];
      case 65:
        return [
          ...common,
          infoCard('USER PROFILE', 'Sample member', 'demo-user@skinsync.local'),
          spacer(18),
          item('Skin profile', 'Combination', Icons.face_outlined, 24),
          item(
            'Privacy',
            'Protected user records require role checks',
            Icons.lock_outline,
            75,
          ),
        ];
      case 66:
        return [
          ...common,
          _adminToolbar('Search products', 67),
          _adminRows('Product', 'Skincare essential', 'Published', 67, 6),
          btn('Add new product', 67),
        ];
      case 67:
        return [
          ...common,
          _adminForm([
            'Product name',
            'Brand',
            'Category',
            'Price',
            'Ingredients',
          ], 'Save product'),
        ];
      case 68:
        return [
          ...common,
          _adminToolbar('Search ingredients', 69),
          _adminRows('Ingredient', 'Skincare compound', 'Reviewed', 69, 7),
          btn('Add ingredient', 69),
        ];
      case 69:
        return [
          ...common,
          _adminForm([
            'Ingredient name',
            'Benefits',
            'Precautions',
            'Usage notes',
          ], 'Save ingredient'),
        ];
      case 70:
        return [
          ...common,
          _adminRows('Routine', 'Morning / evening', 'Template', 71, 6),
          btn('Create routine', 71),
        ];
      case 71:
        return [
          ...common,
          _adminForm([
            'Routine name',
            'Skin type',
            'Morning / evening',
            'Steps',
          ], 'Save routine'),
        ];
      case 72:
        return [
          ...common,
          _adminRows('Article', 'Skincare education', 'Draft', 73, 7),
          btn('Create article', 73),
        ];
      case 73:
        return [
          ...common,
          _adminForm([
            'Article title',
            'Category',
            'Body content',
            'References',
          ], 'Save article'),
        ];
      case 74:
        return [
          ...common,
          Row(
            children: [
              const SkinStat('ANALYSIS REQUESTS', '0'),
              const SizedBox(width: 15),
              const SkinStat('SERVICE STATUS', 'Offline'),
            ],
          ),
          spacer(20),
          note(
            'AI analysis service is not connected. No real model performance statistics are available.',
          ),
          item(
            'Read system settings',
            'Configure services before deployment',
            Icons.settings_outlined,
            75,
          ),
        ];
      case 75:
        return [
          ...common,
          _toggle('Content review notifications', store.tips, store.setTips),
          _toggle(
            'Administrative product updates',
            store.newsletters,
            store.setNewsletters,
          ),
          note(
            'Server-side access control, audit logging and admin APIs must be built separately.',
          ),
        ];
      default:
        return common;
    }
  }

  Widget _adminToolbar(String s, int to) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: s,
            ),
          ),
        ),
        const SizedBox(width: 13),
        SizedBox(
          width: 130,
          child: SkinButton('Search', onTap: () => message('Demo search UI')),
        ),
      ],
    ),
  );
  Widget _adminRows(
    String prefix,
    String detail,
    String status,
    int to,
    int count,
  ) => SkinCard(
    child: Column(
      children: [
        for (var i = 1; i <= count; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.mist,
                child: Icon(Icons.spa_outlined, color: AppColors.forest),
              ),
              title: Text('$prefix $i', style: AppTextStyles.body(14)),
              subtitle: Text(detail, style: AppTextStyles.muted(12)),
              trailing: TextButton(
                onPressed: () => go(to),
                child: Text(status),
              ),
            ),
          ),
      ],
    ),
  );
  Widget _adminForm(List<String> labels, String button) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 760),
    child: SkinCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final s in labels) ...[
            SkinField(
              s,
              controller: s == labels.first ? field : null,
              lines: s == 'Body content' ? 4 : 1,
            ),
            spacer(14),
          ],
          SkinButton(
            button,
            onTap: () =>
                message('Demo-only: no admin changes were sent to a database.'),
          ),
        ],
      ),
    ),
  );
}
