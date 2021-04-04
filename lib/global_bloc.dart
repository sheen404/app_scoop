import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/reminder.dart';

class GlobalBloc {
  Reminder reminder;
  BehaviorSubject<List<Reminder>> _reminderList$;
  BehaviorSubject<List<Reminder>> get reminderList$ => _reminderList$;

  GlobalBloc() {
    _reminderList$ = BehaviorSubject<List<Reminder>>.seeded([]);
    makeReminderList();
  }

  Future removeReminder(Reminder tobeRemoved) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    List<String> reminderJsonList = [];

    var blocList = _reminderList$.value;
    blocList.removeWhere((reminder) => reminder.task == tobeRemoved.task);
    if (blocList.length != 0) {
      for (var blocReminder in blocList) {
        String reminderJson = jsonEncode(blocReminder.toJson());
        reminderJsonList.add(reminderJson);
      }
    }
    sharedUser.setStringList('reminder', reminderJsonList);
    _reminderList$.add(blocList);
  }

  Future updateReminderList(Reminder newReminder) async {
    var blocList = _reminderList$.value;
    blocList.add(newReminder);
    _reminderList$.add(blocList);
    Map<String, dynamic> tempMap = newReminder.toJson();
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    String newReminderJson = jsonEncode(tempMap);
    List<String> reminderJsonList = [];
    if (sharedUser.getStringList('reminder') == null) {
      reminderJsonList.add(newReminderJson);
    } else {
      reminderJsonList = sharedUser.getStringList('reminder');
      reminderJsonList.add(newReminderJson);
    }
    sharedUser.setStringList('reminder', reminderJsonList);
  }

  Future makeReminderList() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    List<String> jsonList = sharedUser.getStringList('reminder');
    List<Reminder> prefList = [];
    if (jsonList == null) {
      return;
    } else {
      for (String jsonReminder in jsonList) {
        Map userMap = jsonDecode(jsonReminder);
        Reminder tempReminder = Reminder.fromJson(userMap);
        prefList.add(tempReminder);
      }
      _reminderList$.add(prefList);
    }
  }

  void dispose() {
    // _selectedDay$.close();
    // _selectedPeriod$.close();
    _reminderList$.close();
  }
}
