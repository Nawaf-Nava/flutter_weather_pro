import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // 1. طلب إذن الإشعارات من المستخدم (Android 13+ & iOS)
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // 2. إعداد قنوات الإشعارات المحلية في Android
      const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      await _localNotifications.initialize(
        const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // 3. الاستماع للإشعارات في الواجهة الأمامية (Foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showForegroundAlert(message);
      });

      // 4. الاشتراك في موضوع تنبيهات الطقس العام
      await _fcm.subscribeToTopic('severe_weather_alerts');
    }
  }

  void _showForegroundAlert(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'weather_alerts_channel',
            'تنبيهات الطقس الحرجة',
            channelDescription: 'إشعارات العواصف والأمطار الغزيرة',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // توجيه المستخدم لشاشة الرادار أو التنبيهات عند النقر على الإشعار
  }

  Future<String?> getDeviceFcmToken() async {
    return await _fcm.getToken();
  }
}