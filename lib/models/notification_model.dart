enum NotificationType { order, offer, system }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  bool isRead;
  final String? actionRoute;
  final String? actionId;
  final String? imageUrl;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.actionRoute,
    this.actionId,
    this.imageUrl,
  });

  String get typeIcon {
    switch (type) {
      case NotificationType.order:
        return '🛵';
      case NotificationType.offer:
        return '🎁';
      case NotificationType.system:
        return '🔔';
    }
  }
}
