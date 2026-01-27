import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'proView.dart';

class SubscriptionManager extends ChangeNotifier {
  static const String _keySubscribed = 'is_subscribed';
  static const String removeAdsId = 'care_paw_weekly_subscription';

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  ProductDetails? product;
  bool _isAvailable = false;
  bool _isLoading = true;

  bool get isAvailable => _isAvailable;
  bool get isLoading => _isLoading;

  /// Check if the user is currently subscribed
  static Future<bool> isSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySubscribed) ?? false;
  }

  /// Mark the user as subscribed (call after successful subscription or free trial)
  static Future<void> markSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySubscribed, true);
  }

  /// Remove subscription status (for testing or unsubscribe)
  static Future<void> removeSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySubscribed);
  }

  /// Check if ads should be shown (inverse of subscription status)
  /// Returns false if user is subscribed (no ads for premium users)
  static Future<bool> shouldShowAds() async {
    final subscribed = await isSubscribed();
    return !subscribed; // Show ads only if NOT subscribed
  }

  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      _listenToPurchase,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        debugPrint("Purchase Stream Error: $error");
      },
    );

    try {
      final Set<String> ids = {removeAdsId};
      final ProductDetailsResponse response = await _iap.queryProductDetails(ids);
      
      if (response.productDetails.isNotEmpty) {
        product = response.productDetails.first;
        debugPrint("Product Details: ${product?.title} - ${product?.price}");
      } else {
        debugPrint("Product not found: $removeAdsId");
        if (response.notFoundIDs.isNotEmpty) {
           debugPrint("Not found IDs: ${response.notFoundIDs}");
        }
      }
    } catch (e) {
      debugPrint("Error querying product: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _listenToPurchase(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        // Optional: Notify UI about pending state
      } else {
        if (purchase.status == PurchaseStatus.error) {
          debugPrint("Purchase Error: ${purchase.error}");
        } else if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          await markSubscribed();
          notifyListeners(); // Notify UI to update
        }

        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    }
  }

  void buySubscription() {
    if (product == null) {
        debugPrint("Cannot buy: Product is null");
        return;
    }
    
    final PurchaseParam param = PurchaseParam(productDetails: product!);
    // For subscriptions, use buyNonConsumable or buyConsumable? 
    // Usually subscriptions are non-consumable in the sense they persist for a duration.
    // However, in_app_purchase uses buyNonConsumable for auto-renewing subscriptions on iOS/Android usually.
    _iap.buyNonConsumable(purchaseParam: param);
  }

  /// Restore purchases (e.g., from Splash Screen or Settings)
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
    debugPrint("🔄 check for restoring purchases...");
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Check if user has access to a paid feature
  /// If not subscribed, navigate to subscription screen
  /// Returns true if has access, false otherwise
  static Future<bool> checkFeatureAccess(BuildContext context, {String? from}) async {
    final subscribed = await isSubscribed();
    if (!subscribed) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Proview(
              // from: from ?? "feature",
            ),
          ),
        );
      }

      return false;
    }
    return true;
  }
}
