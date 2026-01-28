// View_model/ReminderNotifier.dart
import 'package:flutter/material.dart';
import '../activity_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import '../main.dart' show flutterLocalNotificationsPlugin;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderNotifier with ChangeNotifier {
  final List<Map<String, dynamic>> _reminders = [];
  static const String _storageKey = 'dog_reminders_list';

  List<Map<String, dynamic>> get reminders => _reminders;

  ReminderNotifier() {
    _loadReminders();
  }

  // Initialize notifications with timezone
  Future<void> initializeNotifications() async {
    tzdata.initializeTimeZones();
    await _loadReminders();
  }

  Future<void> _loadReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _reminders.clear();
        _reminders.addAll(jsonList.cast<Map<String, dynamic>>());
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading reminders: $e');
    }
  }

  Future<void> _saveReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_reminders);
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      debugPrint('Error saving reminders: $e');
    }
  }

  // Schedule a reminder using flutter_local_notifications
  Future<String> scheduleReminder({
    required Activity activity,
    required DateTime reminderDateTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled =
        prefs.getBool('notifications_enabled') ?? true;

    DateTime scheduledDate = reminderDateTime;
    final now = DateTime.now();

    // Validation: If date is in the past
    if (scheduledDate.isBefore(now)) {
      // If it's just a few seconds/minutes in the past (e.g. user took time to press button),
      // schedule it for immediate future (e.g. 5 seconds from now).
      if (now.difference(scheduledDate).inMinutes < 5) {
        scheduledDate = now.add(const Duration(seconds: 5));
      } else {
        // Significantly in the past, cannot schedule.
        // We should ideally throw an error or handle this upstream.
        // For now, to prevent crash, we return empty or throw specific error.
        throw Exception('Cannot schedule reminder in the past');
      }
    }

    final reminderId = DateTime.now().millisecondsSinceEpoch.toString();

    // Persist locally for UI/state (only JSON-safe values)
    _reminders.add({
      'id': reminderId,
      'activityName': activity.name,
      'reminderDateTime': scheduledDate.toIso8601String(),
      'activityNote': activity.note,
      'scheduledTime': scheduledDate.toIso8601String(),
      'petId': activity.petId,
      'imagePath': activity.imagePath,
      'color': activity.color.value,
    });

    // Create notification details
    const androidDetails = AndroidNotificationDetails(
      'dog_breed_reminders_v2',
      'High Importance Notifications',
      channelDescription: 'Dog Breed app notifications with sound and alert',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
    );
    const details = NotificationDetails(android: androidDetails);

    // Schedule using timezone for reliability
    // Ensure we use the safe 'scheduledDate' which is guaranteed to be future
    final tzTime = tz.TZDateTime.from(scheduledDate, tz.local);

    // Double check to be absolutely sure for the library
    if (tzTime.isBefore(tz.TZDateTime.now(tz.local))) {
      // This should be unreachable due to logic above, but safety first
      throw Exception('Scheduled time $tzTime is before now ${tz.TZDateTime.now(tz.local)}');
    }

    if (notificationsEnabled) {
      final notifId = reminderId.hashCode & 0x7fffffff;

      await flutterLocalNotificationsPlugin.zonedSchedule(
        notifId,
        activity.name,
        activity.note?.isNotEmpty == true ? activity.note! : 'Reminder',
        tzTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: activity.name,
      );
    }

    notifyListeners();
    await _saveReminders();
    return reminderId;
  }

  // Cancel a reminder and its notification
  Future<void> cancelReminder(String reminderId) async {
    try {
      _reminders.removeWhere((r) => r['id'] == reminderId);
      final notifId = reminderId.hashCode & 0x7fffffff;
      await flutterLocalNotificationsPlugin.cancel(notifId);
      await _saveReminders();
      notifyListeners();
    } catch (e) {
      debugPrint('Error canceling reminder: $e');
    }
  }

  // Get reminders for an activity
  List<Map<String, dynamic>> getRemindersForActivity(String activityName) {
    return _reminders
        .where((reminder) => reminder['activityName'] == activityName)
        .toList();
  }

  Future<void> cancelRemindersForActivity(String activityName) async {
    final ids = _reminders
        .where((reminder) => reminder['activityName'] == activityName)
        .map((reminder) => reminder['id'].toString())
        .toList();

    for (final reminderId in ids) {
      final notifId = reminderId.hashCode & 0x7fffffff;
      await flutterLocalNotificationsPlugin.cancel(notifId);
    }

    _reminders.removeWhere((reminder) => reminder['activityName'] == activityName);
    await _saveReminders();
    notifyListeners();
  }

  bool hasReminderForActivity(String activityName) {
    return _reminders.any((reminder) => reminder['activityName'] == activityName);
  }

  Map<String, dynamic>? getReminderForActivityAtTime(
      String activityName, DateTime time) {
    try {
      return _reminders.firstWhere((reminder) =>
      reminder['activityName'] == activityName &&
          DateTime.parse(reminder['scheduledTime']).isAtSameMomentAs(time));
    } catch (e) {
      return null;
    }
  }

  Future<void> cancelAllReminders() async {
    _reminders.clear();
    await flutterLocalNotificationsPlugin.cancelAll();
    await _saveReminders();
    notifyListeners();
  }

  List<Map<String, dynamic>> getUpcomingReminders() {
    final now = DateTime.now();
    return _reminders.where((reminder) {
      final reminderTime = DateTime.parse(reminder['scheduledTime']);
      return reminderTime.isAfter(now);
    }).toList();
  }

  List<Map<String, dynamic>> getPastReminders() {
    final now = DateTime.now();
    return _reminders.where((reminder) {
      final reminderTime = DateTime.parse(reminder['scheduledTime']);
      return reminderTime.isBefore(now);
    }).toList();
  }

  int getRemindersCountForDate(DateTime date, {String? petId}) {
    return _reminders.where((reminder) {
      final reminderTime = DateTime.parse(reminder['scheduledTime']);
      final isSameDay = reminderTime.year == date.year &&
          reminderTime.month == date.month &&
          reminderTime.day == date.day;
      final isSamePet = petId == null || reminder['petId'] == petId;
      return isSameDay && isSamePet;
    }).length;
  }

  void checkDueReminders(BuildContext context) {
    // With scheduled notifications, this can be a no-op.
  }

  void startReminderChecker(BuildContext context, {int intervalSeconds = 30}) {
    // No periodic checks needed; notifications are scheduled.
  }
}
