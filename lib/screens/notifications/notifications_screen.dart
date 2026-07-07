import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/notification_model.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications 🔔',
        actions: [
          TextButton(
            onPressed: () =>
                context.read<NotificationProvider>().markAllAsRead(),
            child: Text(
              'Mark all read',
              style: AppTextStyles.labelSmall
                  .copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (_, provider, __) {
          if (provider.notifications.isEmpty) {
            return const EmptyState(
              emoji: '🔔',
              title: 'No notifications',
              subtitle: 'You\'re all caught up!',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.notifications.length,
            itemBuilder: (_, i) {
              final n = provider.notifications[i];
              return _NotifTile(
                notification: n,
                onTap: () => provider.markAsRead(n.id),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotifTile({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? (isDark ? AppColors.darkSurfaceVariant : AppColors.surface)
              : AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: notification.isRead
                ? AppColors.border
                : AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: notification.isRead
                    ? AppColors.surfaceVariant
                    : AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(notification.typeIcon,
                    style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: notification.isRead
                          ? FontWeight.w500
                          : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _timeAgo(notification.createdAt),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
