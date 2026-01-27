import 'package:flutter/material.dart';

class AdService {
  static Future<void> showInterstitialAd(VoidCallback onAdDismissed) async {
    // Mock implementation - immediately call the callback
    // In a real app, load and show the ad here
    onAdDismissed();
  }
}
