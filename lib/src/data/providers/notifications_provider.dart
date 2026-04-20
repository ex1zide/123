import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_provider.g.dart';

/// Single notification entity.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isRead,
    this.icon,
  });

  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String? icon;

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        body: body,
        timestamp: timestamp,
        isRead: isRead ?? this.isRead,
        icon: icon,
      );
}

/// Notification center state with unread count tracking.
@Riverpod(keepAlive: true)
class NotificationsController extends _$NotificationsController {
  @override
  List<AppNotification> build() {
    // Mock notifications for demonstration
    final now = DateTime.now();
    return [
      AppNotification(
        id: '1',
        title: 'Договор проверен ✅',
        body: 'ИИ-юрист завершил анализ вашего договора аренды. Рисков не обнаружено.',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isRead: false,
        icon: '📄',
      ),
      AppNotification(
        id: '2',
        title: 'Новая статья в законах РК',
        body: 'Обновление Трудового кодекса РК — новые правила дистанционной работы вступают в силу.',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
        icon: '📰',
      ),
      AppNotification(
        id: '3',
        title: 'Топ-юрист доступен',
        body: 'Тимур Ахметов (Корпоративное право, ⭐ 5.0) открыл новые слоты для консультаций.',
        timestamp: now.subtract(const Duration(hours: 6)),
        isRead: false,
        icon: '👨‍⚖️',
      ),
      AppNotification(
        id: '4',
        title: 'Добро пожаловать в LegalHelp KZ!',
        body: 'Вам доступно 10 бесплатных запросов к ИИ-юристу. Начните прямо сейчас!',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
        icon: '🎉',
      ),
    ];
  }

  /// Number of unread notifications.
  int get unreadCount => state.where((n) => !n.isRead).length;

  /// Mark a single notification as read.
  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  /// Mark all notifications as read.
  void markAllAsRead() {
    state = [for (final n in state) n.copyWith(isRead: true)];
  }
}
