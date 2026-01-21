import 'package:flutter/cupertino.dart';

class HomeViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  int _calendarTabIndex = 0;
  int get calendarTabIndex => _calendarTabIndex;

  set selectedIndex(int value) {
    if (_selectedIndex != value) {
      _selectedIndex = value;
      notifyListeners();
    }
  }

  set calendarTabIndex(int value) {
    if (_calendarTabIndex != value) {
      _calendarTabIndex = value;
      notifyListeners();
    }
  }
}
