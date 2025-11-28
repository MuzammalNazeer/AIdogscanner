import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // For web - use relative URL or your deployed backend
      return '/api';
    } else {
      // For mobile - detect platform
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8081/api';
      } else if (Platform.isIOS) {
        return 'http://localhost:8081/api';
      } else {
        return 'http://localhost:8081/api';
      }
    }
  }

  static String getHygieneLogsUrl(int petId) {
    return '$baseUrl/hygiene-logs/pet/$petId';
  }
}