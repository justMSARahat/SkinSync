import 'package:flutter/material.dart';
import '../../../core/widgets/screen_renderer.dart';

/// Figma screen 01: Splash Screen
/// https://www.figma.com/design/40AcqhqyGUZydVksrKk32d
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const ScreenRenderer(screenId: 1);
}
