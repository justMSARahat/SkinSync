import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'app_router.dart';

class SkinSyncApp extends StatelessWidget {
  const SkinSyncApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SkinSync',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    onGenerateRoute: AppRouter.onGenerateRoute,
    initialRoute: AppRouter.initialRoute,
  );
}
