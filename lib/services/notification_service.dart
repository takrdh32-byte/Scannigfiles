import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../models/medicine.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings);
  }

  /// Schedules a reminder 7 days before expiry, and one on the expiry day,
  /// both fired at 9:00 AM local time. Uses a stable per-medicine id.
  static Future<void> scheduleForMedicine(Medicine m) async {
    final baseId = m.id.hashCode & 0x7fffffff;
    await _cancelForMedicine(m);

    final weekBefore = m.expiryDate.subtract(const Duration(days: 7));
    if (weekBefore.isAfter(DateTime.now())) {
      await _schedule(
        id: baseId,
        title: 'DawaCheck ⏰',
        body: '${m.name} expires in 7 days',
        date: weekBefore,
      );
    }
    if (m.expiryDate.isAfter(DateTime.now())) {
      await _schedule(
        id: baseId + 1,
        title: 'DawaCheck ⚠️',
        body: '${m.name} expires today',
        date: m.expiryDate,
      );
    }
  }

  static Future<void> _cancelForMedicine(Medicine m) async {
    final baseId = m.id.hashCode & 0x7fffffff;
    await _plugin.cancel(baseId);
    await _plugin.cancel(baseId + 1);
  }

  static Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    final scheduled = tz.TZDateTime.local(date.year, date.month, date.day, 9, 0);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'dawacheck_expiry',
          'Expiry Reminders',
          channelDescription: 'Reminders before medicines expire',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelForMedicine(Medicine m) => _cancelForMedicine(m);
}
