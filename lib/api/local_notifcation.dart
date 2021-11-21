import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

///required packages timezone: ^0.8.0
///rxdart: ^0.27.2
///flutter_local_notifications: ^9.0.0 with gradle 7.2

class LocalNotification {
  static bool subScribedToNotifications = false;
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String>();
  static bool inisilizedNotfications = false;

  static Future _notificationDetails() async {
    // final styleInfo=BigPictureStyleInformation(bigpicture,largeIcon: Filepath)

    return NotificationDetails(
      android: AndroidNotificationDetails(
        '1',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        // styleInformation: StyleInformation
      ),
    );
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('mipmap/ic_launcher');
    final InitializationSettings setting =
        InitializationSettings(android: android);

    if (initScheduled) {
      // 'inilizing the timezone '
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }

    //when app is closed
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotification.add(details.payload!);
    }

    await _notifications.initialize(setting,
        onSelectNotification: (payload) async {
      onNotification.add(payload!);
    });

    //requierd to inisilize timezone package before using it
  }

  static Future showNotfication({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  //scehular daily notification
  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    int? hour,
    int? minutes,
    required DateTime notiDate,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _scheduleDaily(Time(hour!, minutes!)),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    final conculation = scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
    return conculation;
  }
}
