import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for a subscription plan fetched from Firestore (managed by Admin).
class SubscriptionPlan {
  final String id;
  final String name;
  final String productId;
  final int durationMonths;
  final double pricePerMonth;
  final double totalPrice;
  final String currency;
  final String? badge;
  final String? badgeColor;
  final String? savingsText;
  final String? bottomNote;
  final List<String> features;
  final bool isActive;
  final bool isPopular;
  final int sortOrder;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.productId,
    required this.durationMonths,
    required this.pricePerMonth,
    required this.totalPrice,
    this.currency = 'USD',
    this.badge,
    this.badgeColor,
    this.savingsText,
    this.bottomNote,
    required this.features,
    required this.isActive,
    required this.isPopular,
    required this.sortOrder,
  });

  factory SubscriptionPlan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubscriptionPlan(
      id: doc.id,
      name: data['name'] ?? '',
      productId: data['productId'] ?? '',
      durationMonths: (data['durationMonths'] ?? 1).toInt(),
      pricePerMonth: (data['pricePerMonth'] ?? 0).toDouble(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'USD',
      badge: data['badge'],
      badgeColor: data['badgeColor'],
      savingsText: data['savingsText'],
      bottomNote: data['bottomNote'],
      features: List<String>.from(data['features'] ?? []),
      isActive: data['isActive'] ?? true,
      isPopular: data['isPopular'] ?? false,
      sortOrder: (data['sortOrder'] ?? 99).toInt(),
    );
  }
}

/// Service to load subscription plans from Firestore (admin-managed).
class SubscriptionPlansService {
  static final SubscriptionPlansService _instance =
      SubscriptionPlansService._internal();
  factory SubscriptionPlansService() => _instance;
  SubscriptionPlansService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream of active plans, ordered by sortOrder.
  Stream<List<SubscriptionPlan>> watchPlans() {
    return _firestore
        .collection('subscription_plans')
        .orderBy('sortOrder')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => SubscriptionPlan.fromFirestore(d)).toList(),
        );
  }

  /// One-time fetch of active plans.
  Future<List<SubscriptionPlan>> getPlans() async {
    try {
      final snap = await _firestore
          .collection('subscription_plans')
          .orderBy('sortOrder')
          .get();

      final plans = snap.docs.map((d) => SubscriptionPlan.fromFirestore(d)).toList();
      print('Fetched ${plans.length} plans from Firestore');
      return plans;
    } catch (e) {
      print('Error fetching plans: $e');
      return [];
    }
  }
}
