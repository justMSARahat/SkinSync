import 'package:flutter/material.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/onboarding/screens/welcome_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';
import '../features/auth/screens/email_verification_screen.dart';
import '../features/home/screens/home_dashboard_screen.dart';
import '../features/account/screens/user_profile_screen.dart';
import '../features/account/screens/edit_profile_screen.dart';
import '../features/account/screens/settings_screen.dart';
import '../features/account/screens/notification_center_screen.dart';
import '../features/account/screens/help_support_screen.dart';
import '../features/account/screens/about_skinsync_screen.dart';
import '../features/skin_analysis/screens/skin_assessment_intro_screen.dart';
import '../features/skin_analysis/screens/skin_assessment_questionnaire_screen.dart';
import '../features/skin_analysis/screens/camera_capture_screen.dart';
import '../features/skin_analysis/screens/photo_upload_screen.dart';
import '../features/skin_analysis/screens/photo_preview_screen.dart';
import '../features/skin_analysis/screens/analysis_loading_screen.dart';
import '../features/skin_analysis/screens/analysis_results_screen.dart';
import '../features/skin_analysis/screens/skin_concerns_screen.dart';
import '../features/skin_analysis/screens/skin_profile_screen.dart';
import '../features/skin_analysis/screens/analysis_history_screen.dart';
import '../features/routines/screens/routine_dashboard_screen.dart';
import '../features/routines/screens/morning_routine_screen.dart';
import '../features/routines/screens/evening_routine_screen.dart';
import '../features/routines/screens/routine_details_screen.dart';
import '../features/routines/screens/skincare_step_details_screen.dart';
import '../features/routines/screens/routine_completion_screen.dart';
import '../features/routines/screens/routine_calendar_screen.dart';
import '../features/routines/screens/routine_customization_screen.dart';
import '../features/products/screens/product_discovery_screen.dart';
import '../features/products/screens/product_search_screen.dart';
import '../features/products/screens/product_categories_screen.dart';
import '../features/products/screens/product_details_screen.dart';
import '../features/products/screens/product_ingredients_screen.dart';
import '../features/products/screens/ingredient_search_screen.dart';
import '../features/products/screens/ingredient_details_screen.dart';
import '../features/products/screens/recommended_products_screen.dart';
import '../features/products/screens/favorite_products_screen.dart';
import '../features/reminders/screens/reminder_dashboard_screen.dart';
import '../features/reminders/screens/create_reminder_screen.dart';
import '../features/reminders/screens/edit_reminder_screen.dart';
import '../features/reminders/screens/reminder_settings_screen.dart';
import '../features/reminders/screens/notification_preferences_screen.dart';
import '../features/progress/screens/progress_dashboard_screen.dart';
import '../features/progress/screens/upload_progress_photo_screen.dart';
import '../features/progress/screens/progress_photo_gallery_screen.dart';
import '../features/progress/screens/before_after_screen.dart';
import '../features/progress/screens/progress_timeline_screen.dart';
import '../features/progress/screens/skincare_journal_screen.dart';
import '../features/progress/screens/create_journal_entry_screen.dart';
import '../features/progress/screens/journal_entry_details_screen.dart';
import '../features/progress/screens/skincare_history_screen.dart';
import '../features/education/screens/education_home_screen.dart';
import '../features/education/screens/article_categories_screen.dart';
import '../features/education/screens/article_list_screen.dart';
import '../features/education/screens/article_details_screen.dart';
import '../features/education/screens/saved_articles_screen.dart';
import '../features/admin/screens/admin_login_screen.dart';
import '../features/admin/screens/admin_dashboard_screen.dart';
import '../features/admin/screens/user_management_screen.dart';
import '../features/admin/screens/user_details_screen.dart';
import '../features/admin/screens/product_management_screen.dart';
import '../features/admin/screens/product_editor_screen.dart';
import '../features/admin/screens/ingredient_management_screen.dart';
import '../features/admin/screens/ingredient_editor_screen.dart';
import '../features/admin/screens/routine_management_screen.dart';
import '../features/admin/screens/routine_editor_screen.dart';
import '../features/admin/screens/content_management_screen.dart';
import '../features/admin/screens/article_editor_screen.dart';
import '../features/admin/screens/analysis_monitoring_screen.dart';
import '../features/admin/screens/system_settings_screen.dart';
import '../features/system/screens/loading_screen.dart';
import '../features/system/screens/no_internet_screen.dart';
import '../features/system/screens/empty_state_screen.dart';
import '../features/system/screens/error_screen.dart';
import '../features/system/screens/access_denied_screen.dart';
import '../features/system/screens/page_not_found_screen.dart';
import '../features/system/screens/delete_confirmation_screen.dart';
import '../features/system/screens/logout_confirmation_screen.dart';

/// Every item in the approved 83-frame Figma inventory has a concrete Dart screen.
abstract final class AppRouter {
  static const initialRoute = '/screen/1';
  static final Map<int, WidgetBuilder> builders = {
    1: (context) => const SplashScreen(),
    2: (context) => const OnboardingScreen(),
    3: (context) => const WelcomeScreen(),
    4: (context) => const LoginScreen(),
    5: (context) => const RegisterScreen(),
    6: (context) => const ForgotPasswordScreen(),
    7: (context) => const ResetPasswordScreen(),
    8: (context) => const EmailVerificationScreen(),
    9: (context) => const HomeDashboardScreen(),
    10: (context) => const UserProfileScreen(),
    11: (context) => const EditProfileScreen(),
    12: (context) => const SettingsScreen(),
    13: (context) => const NotificationCenterScreen(),
    14: (context) => const HelpSupportScreen(),
    15: (context) => const AboutSkinsyncScreen(),
    16: (context) => const SkinAssessmentIntroScreen(),
    17: (context) => const SkinAssessmentQuestionnaireScreen(),
    18: (context) => const CameraCaptureScreen(),
    19: (context) => const PhotoUploadScreen(),
    20: (context) => const PhotoPreviewScreen(),
    21: (context) => const AnalysisLoadingScreen(),
    22: (context) => const AnalysisResultsScreen(),
    23: (context) => const SkinConcernsScreen(),
    24: (context) => const SkinProfileScreen(),
    25: (context) => const AnalysisHistoryScreen(),
    26: (context) => const RoutineDashboardScreen(),
    27: (context) => const MorningRoutineScreen(),
    28: (context) => const EveningRoutineScreen(),
    29: (context) => const RoutineDetailsScreen(),
    30: (context) => const SkincareStepDetailsScreen(),
    31: (context) => const RoutineCompletionScreen(),
    32: (context) => const RoutineCalendarScreen(),
    33: (context) => const RoutineCustomizationScreen(),
    34: (context) => const ProductDiscoveryScreen(),
    35: (context) => const ProductSearchScreen(),
    36: (context) => const ProductCategoriesScreen(),
    37: (context) => const ProductDetailsScreen(),
    38: (context) => const ProductIngredientsScreen(),
    39: (context) => const IngredientSearchScreen(),
    40: (context) => const IngredientDetailsScreen(),
    41: (context) => const RecommendedProductsScreen(),
    42: (context) => const FavoriteProductsScreen(),
    43: (context) => const ReminderDashboardScreen(),
    44: (context) => const CreateReminderScreen(),
    45: (context) => const EditReminderScreen(),
    46: (context) => const ReminderSettingsScreen(),
    47: (context) => const NotificationPreferencesScreen(),
    48: (context) => const ProgressDashboardScreen(),
    49: (context) => const UploadProgressPhotoScreen(),
    50: (context) => const ProgressPhotoGalleryScreen(),
    51: (context) => const BeforeAfterScreen(),
    52: (context) => const ProgressTimelineScreen(),
    53: (context) => const SkincareJournalScreen(),
    54: (context) => const CreateJournalEntryScreen(),
    55: (context) => const JournalEntryDetailsScreen(),
    56: (context) => const SkincareHistoryScreen(),
    57: (context) => const EducationHomeScreen(),
    58: (context) => const ArticleCategoriesScreen(),
    59: (context) => const ArticleListScreen(),
    60: (context) => const ArticleDetailsScreen(),
    61: (context) => const SavedArticlesScreen(),
    62: (context) => const AdminLoginScreen(),
    63: (context) => const AdminDashboardScreen(),
    64: (context) => const UserManagementScreen(),
    65: (context) => const UserDetailsScreen(),
    66: (context) => const ProductManagementScreen(),
    67: (context) => const ProductEditorScreen(),
    68: (context) => const IngredientManagementScreen(),
    69: (context) => const IngredientEditorScreen(),
    70: (context) => const RoutineManagementScreen(),
    71: (context) => const RoutineEditorScreen(),
    72: (context) => const ContentManagementScreen(),
    73: (context) => const ArticleEditorScreen(),
    74: (context) => const AnalysisMonitoringScreen(),
    75: (context) => const SystemSettingsScreen(),
    76: (context) => const LoadingScreen(),
    77: (context) => const NoInternetScreen(),
    78: (context) => const EmptyStateScreen(),
    79: (context) => const ErrorScreen(),
    80: (context) => const AccessDeniedScreen(),
    81: (context) => const PageNotFoundScreen(),
    82: (context) => const DeleteConfirmationScreen(),
    83: (context) => const LogoutConfirmationScreen(),
  };
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final id = int.tryParse(settings.name?.split('/').last ?? '') ?? 1;
    final builder = builders[id] ?? builders[81]!;
    return MaterialPageRoute<void>(settings: settings, builder: builder);
  }
  static void go(BuildContext context, int id, {bool replace = false}) {
    if (replace) {
      Navigator.of(context).pushNamedAndRemoveUntil('/screen/$id', (_) => false);
    } else {
      Navigator.of(context).pushNamed('/screen/$id');
    }
  }
}
