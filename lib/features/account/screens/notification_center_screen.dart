
import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/botanical_widgets.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState
    extends State<NotificationCenterScreen> {

  // Sample notifications for the UI.
  // We'll replace these with real data later.
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Morning ritual',
      'message': 'Remember to moisturize your skin.',
      'time': '8:00 AM',
      'icon': Icons.wb_sunny_outlined,
      'route': 27,
      'read': false,
    },
    {
      'title': 'Your skin check-in',
      'message': 'Time for your weekly progress picture.',
      'time': 'Yesterday',
      'icon': Icons.camera_alt_outlined,
      'route': 49,
      'read': false,
    },
    {
      'title': 'Skincare journal',
      'message': 'Reflect on how your skin feels today.',
      'time': '2 days ago',
      'icon': Icons.menu_book_outlined,
      'route': 53,
      'read': true,
    },
  ];

  int get unreadCount {
    return notifications.where((item) => item['read'] == false).length;
  }

  // Mark a notification as read and open its destination.
  void openNotification(int index) {
    setState(() {
      notifications[index]['read'] = true;
    });

    final route = notifications[index]['route'] as int;
    AppRouter.go(context, route);
  }

  // Mark all notifications as read.
  void markAllAsRead() {
    setState(() {
      for (final notification in notifications) {
        notification['read'] = true;
      }
    });
  }

  // Reusable notification card.
  Widget notificationCard(int index) {
    final notification = notifications[index];
    final isRead = notification['read'] as bool;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SkinCard(
        color: isRead ? AppColors.paper : AppColors.mist,
        onTap: () => openNotification(index),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: AppColors.sand,
              child: Icon(
                notification['icon'] as IconData,
                color: AppColors.forest,
                size: 23,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'] as String,
                          style: AppTextStyles.body(14).copyWith(
                            fontWeight: isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                      ),

                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.forest,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  Text(
                    notification['message'] as String,
                    style: AppTextStyles.muted(12),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    notification['time'] as String,
                    style: AppTextStyles.label(10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom navigation button.
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

  // Original SkinSync navigation menu.
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
          'Notifications',
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
                  'Notifications',
                  style: AppTextStyles.display(35),
                ),

                const SizedBox(height: 8),

                Text(
                  'A little nudge, just when you need it.',
                  style: AppTextStyles.muted(13),
                ),

                const SizedBox(height: 28),

                // Summary and mark-all-read action.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$unreadCount unread',
                      style: AppTextStyles.label(12),
                    ),

                    TextButton(
                      onPressed: unreadCount == 0
                          ? null
                          : markAllAsRead,
                      child: const Text(
                        'Mark all as read',
                        style: TextStyle(
                          color: AppColors.forest,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Notification list
                if (notifications.isEmpty)
                  SkinCard(
                    color: AppColors.mist,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          color: AppColors.forest,
                          size: 52,
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'All caught up!',
                          style: AppTextStyles.display(25),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Your notifications will appear here.',
                          style: AppTextStyles.muted(13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ...List.generate(
                    notifications.length,
                    notificationCard,
                  ),

                const SizedBox(height: 20),

                SkinButton(
                  'Notification preferences',
                  outlined: true,
                  onTap: () => AppRouter.go(context, 47),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Text(
                    'Sample notifications for UI preview',
                    style: AppTextStyles.muted(11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
