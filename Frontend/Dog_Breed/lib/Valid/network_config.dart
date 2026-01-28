import 'package:flutter/foundation.dart';

class NetworkConfig {
  static List<String> getBaseUrls(int petId) {
    const endpoint = '/api/hygiene-logs/pet';

    // For web - use relative URLs or deployed backend
    if (kIsWeb) {
      return ['/api/hygiene-logs/pet/$petId'];
    }

    // Common local IPs to try
    final localIPs = [
      '10.0.2.2',        // Android emulator
      '192.168.100.39',  // Your specific IP
      '192.168.1.100',   // Common home IP
      '192.168.0.100',   // Another common IP
      'localhost',       // Localhost
    ];

    return localIPs.map((ip) => 'http://$ip:8081$endpoint/$petId').toList();
  }

  static Duration get timeoutDuration => const Duration(seconds: 8);
}