class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}

class NotificationManager {
  static final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Check-in Reminder',
      message: 'Your check-in time is at 2:00 PM today. Please ensure you have all required documents.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: '2',
      title: 'Breakfast Service',
      message: 'Breakfast is being served in the restaurant until 10:00 AM.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationModel(
      id: '3',
      title: 'Room Service',
      message: 'Your room service order has been confirmed and will be delivered shortly.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  static List<NotificationModel> getNotifications() {
    return _notifications;
  }

  static int getUnreadCount() {
    return _notifications.where((notification) => !notification.isRead).length;
  }

  static void markAsRead(String id) {
    final index = _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      _notifications[index] = NotificationModel(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        timestamp: _notifications[index].timestamp,
        isRead: true,
      );
    }
  }

  static void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = NotificationModel(
        id: _notifications[i].id,
        title: _notifications[i].title,
        message: _notifications[i].message,
        timestamp: _notifications[i].timestamp,
        isRead: true,
      );
    }
  }
} 