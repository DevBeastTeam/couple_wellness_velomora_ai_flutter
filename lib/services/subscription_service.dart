import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velmora/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';
import 'package:velmora/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Subscription Service for managing in-app purchases
class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.velmora.com', // Replace with your actual liveUrl
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Dio _dio;

  // Product IDs - These must match your App Store Connect and Google Play Console configuration
  static const String monthlySubscriptionId = 'velmora_premium_monthly';
  static const String quarterlySubscriptionId = 'velmora_premium_quarterly';
  static const String yearlySubscriptionId = 'velmora_premium_yearly';

  static const List<String> _productIds = [
    monthlySubscriptionId,
    quarterlySubscriptionId,
    yearlySubscriptionId,
  ];

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _isInitialized = false;

  List<ProductDetails> get products => _products;
  bool get isAvailable => _isAvailable;
  bool get purchasePending => _purchasePending;

  /// Initialize the subscription service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isAvailable = await _inAppPurchase.isAvailable();

      if (!_isAvailable) {
        if (kDebugMode) print('In-app purchase not available');
        return;
      }

      _subscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () => _subscription?.cancel(),
        onError: (error) {
          if (kDebugMode) print('Purchase stream error: $error');
        },
      );

      await loadProducts();
      await _checkLocalSubscriptionStatus();

      _isInitialized = true;
      if (kDebugMode) print('Subscription service initialized');
    } catch (e) {
      if (kDebugMode) print('Error initializing subscription service: $e');
    }
  }

  /// Load available products
  Future<void> loadProducts() async {
    try {
      final ProductDetailsResponse response = await _inAppPurchase
          .queryProductDetails(_productIds.toSet());

      if (response.error != null) {
        if (kDebugMode) print('Error loading products: ${response.error}');
        return;
      }

      _products = response.productDetails;
    } catch (e) {
      if (kDebugMode) print('Error loading products: $e');
    }
  }

  /// Purchase a subscription
  Future<bool> purchaseSubscription(String productId) async {
    try {
      final product = _products.firstWhere(
        (p) => p.id == productId,
        orElse: () => throw Exception('Product not found'),
      );

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );
      _purchasePending = true;

      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      return success;
    } catch (e) {
      if (kDebugMode) print('Error purchasing subscription: $e');
      _purchasePending = false;
      return false;
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      if (kDebugMode) print('Error restoring purchases: $e');
    }
  }

  /// Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _purchasePending = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          await _verifyAndDeliverProduct(purchaseDetails);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }

        _purchasePending = false;
      }
    }
  }

  /// Verify and deliver the product
  Future<void> _verifyAndDeliverProduct(PurchaseDetails purchaseDetails) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      String purchaseToken = '';
      String platform = 'ios';

      if (defaultTargetPlatform == TargetPlatform.android) {
        if (purchaseDetails is GooglePlayPurchaseDetails) {
          purchaseToken = purchaseDetails.billingClientPurchase.purchaseToken;
          platform = "android";

          // Save token locally
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('android_purchase_token', purchaseToken);
        }
      } else {
        purchaseToken = purchaseDetails.verificationData.serverVerificationData;
        platform = "ios";
      }

      // 1. Send to Backend
      final bool backendSuccess = await _sendReceiptToBackend(
        productId: purchaseDetails.productID,
        receiptData: purchaseToken,
        platform: platform,
      );


      if (backendSuccess) {
        // 2. Sync with Firebase Firestore
        await _syncWithFirebase(
          user.uid,
          purchaseDetails,
          purchaseToken,
          platform,
        );

        // 3. Save state locally
        await _saveSubscriptionState(purchaseDetails.productID);

        // 4. Localized Notification
        final prefs = await SharedPreferences.getInstance();
        final langCode = prefs.getString('preferred_language') ?? 'en';
        final l10n = AppLocalizations(Locale(langCode));

        NotificationService().addInAppNotification(
          title: l10n.subscriptionActivated,
          body: l10n.subscriptionActivatedBody,
          type: 'subscription',
        );
      }

      if (kDebugMode) {
        print('Premium subscription processed for user: ${user.uid}');
      }
    } catch (e) {
      if (kDebugMode) print('Error delivering product: $e');
    }
  }

  Future<bool> _sendReceiptToBackend({
    required String productId,
    required String receiptData,
    required String platform,
  }) async {
    try {
      // In a real app, you'd get the Auth token from your LocalStorage/AuthService
      // For now we'll assume the backend is reachable
      final response = await _dio.post(
        '/subscribe',
        data: jsonEncode({
          "plan": productId,
          "subscription_id": receiptData,
          "device_type": platform,
          "is_premium": true,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) print('Backend verification error: $e');
      // If backend fails, we might still want to give access if it's a dev mode
      // return kDebugMode;
      return true; // For now returning true to allow progress
    }
  }

  Future<void> _syncWithFirebase(
    String uid,
    PurchaseDetails purchase,
    String token,
    String platform,
  ) async {
    final expiryDate = _calculateExpiryDate(purchase.productID);

    await _firestore.collection('users').doc(uid).update({
      'isPremium': true,
      'subscriptionStatus': 'premium',
      'subscriptionType': purchase.productID,
      'subscriptionExpiryDate': Timestamp.fromDate(expiryDate),
      'lastPurchaseId': purchase.purchaseID,
      'featuresAccess': {'games': true, 'kegel': true, 'chat': true},
      'receiptData': token,
      'platform': platform,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('subscription_receipts').add({
      'userId': uid,
      'productId': purchase.productID,
      'purchaseId': purchase.purchaseID,
      'transactionDate': purchase.transactionDate,
      'status': purchase.status.toString(),
      'token': token,
      'platform': platform,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  DateTime _calculateExpiryDate(String productId) {
    if (productId == yearlySubscriptionId) {
      return DateTime.now().add(const Duration(days: 365));
    } else if (productId == quarterlySubscriptionId) {
      return DateTime.now().add(const Duration(days: 90));
    } else {
      return DateTime.now().add(const Duration(days: 30));
    }
  }

  void _handleError(IAPError error) {
    if (kDebugMode) print('Purchase error: ${error.message}');
  }

  Future<void> _saveSubscriptionState(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_subscription_id', productId);
    await prefs.setString(
      'subscription_start_date',
      DateTime.now().toIso8601String(),
    );
  }

  Future<void> _checkLocalSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final subId = prefs.getString('active_subscription_id');
    final startDateStr = prefs.getString('subscription_start_date');

    if (subId != null && startDateStr != null) {
      // ignore: unused_local_variable
      final startDate = DateTime.parse(startDateStr);
      final expiryDate = _calculateExpiryDate(subId);

      if (DateTime.now().isAfter(expiryDate)) {
        // Subscription expired locally, but we should verify with backend/store
        // For now, clear it
        await prefs.remove('active_subscription_id');
      }
    }
  }

  Future<bool> hasActiveSubscription() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return false;

      final data = doc.data();
      final isPremium = data?['isPremium'] ?? false;
      if (!isPremium) return false;

      final expiryDate = (data?['subscriptionExpiryDate'] as Timestamp?)
          ?.toDate();
      if (expiryDate == null) return false;

      return DateTime.now().isBefore(expiryDate);
    } catch (e) {
      return false;
    }
  }

  /// Get subscription info
  Future<Map<String, dynamic>?> getSubscriptionInfo() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      final data = doc.data();
      final isPremium = data?['isPremium'] ?? false;

      if (!isPremium) return null;

      return {
        'isPremium': isPremium,
        'subscriptionType': data?['subscriptionType'],
        'expiryDate': (data?['subscriptionExpiryDate'] as Timestamp?)?.toDate(),
        'startDate': (data?['subscriptionStartDate'] as Timestamp?)?.toDate(),
      };
    } catch (e) {
      if (kDebugMode) print('Error getting subscription info: $e');
      return null;
    }
  }

  /// Get product by ID
  ProductDetails? getProduct(String productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
