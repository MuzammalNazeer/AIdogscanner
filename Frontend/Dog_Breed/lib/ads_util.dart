import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static Future<void> showAppOpenAd() async {
    // Stub implementation
    debugPrint('AdService.showAppOpenAd called');
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

class NativeAdWidget extends StatelessWidget {
  final String location;
  final double height;
  final TemplateType templateType;

  const NativeAdWidget({
    Key? key,
    required this.location,
    required this.height,
    required this.templateType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Text('Native Ad Placeholder ($location)'),
      ),
    );
  }
}
