import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  // Profile data
  String _firstName = 'Muzammal';
  String _lastName = '';
  String _gender = '';
  String _email = 'nazirmuzammal28@gmail.com';
  String _phone = '';
  String _country = 'Pakistan';
  String _city = '';
  String _address = '';
  File? _profileImageFile;

  // Getters
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get gender => _gender;
  String get email => _email;
  String get phone => _phone;
  String get country => _country;
  String get city => _city;
  String get address => _address;
  File? get profileImageFile => _profileImageFile;

  // SharedPreferences keys
  static const String _keyFirstName = 'first_name';
  static const String _keyLastName = 'last_name';
  static const String _keyGender = 'gender';
  static const String _keyEmail = 'email';
  static const String _keyPhone = 'phone';
  static const String _keyCountry = 'country';
  static const String _keyCity = 'city';
  static const String _keyAddress = 'address';
  static const String _keyProfileImage = 'profile_image_path';

  ProfileProvider() {
    _loadAllData();
  }

  // Load all saved data
  Future<void> _loadAllData() async {
    final prefs = await SharedPreferences.getInstance();

    _firstName = prefs.getString(_keyFirstName) ?? 'Muzammal';
    _lastName = prefs.getString(_keyLastName) ?? '';
    _gender = prefs.getString(_keyGender) ?? '';
    _email = prefs.getString(_keyEmail) ?? 'anapplemuzammal@gmail.com';
    _phone = prefs.getString(_keyPhone) ?? '';
    _country = prefs.getString(_keyCountry) ?? 'Pakistan';
    _city = prefs.getString(_keyCity) ?? '';
    _address = prefs.getString(_keyAddress) ?? '';

    final savedPath = prefs.getString(_keyProfileImage);
    if (savedPath != null) {
      final file = File(savedPath);
      if (file.existsSync()) {
        _profileImageFile = file;
      }
    }
    notifyListeners();
  }

  // Update methods
  Future<void> updateFirstName(String value) async {
    _firstName = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFirstName, value);
  }

  Future<void> updateLastName(String value) async {
    _lastName = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastName, value);
  }

  Future<void> updateGender(String value) async {
    _gender = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGender, value);
  }

  Future<void> updateEmail(String value) async {
    _email = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, value);
  }

  Future<void> updatePhone(String value) async {
    _phone = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhone, value);
  }

  Future<void> updateCountry(String value) async {
    _country = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCountry, value);
  }

  Future<void> updateCity(String value) async {
    _city = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCity, value);
  }

  Future<void> updateAddress(String value) async {
    _address = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAddress, value);
  }

  Future<void> updateProfileImage(String path) async {
    _profileImageFile = File(path);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileImage, path);
  }
}
