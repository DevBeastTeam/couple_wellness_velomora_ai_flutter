import 'package:velmora/constants/app_colors.dart';
import 'package:velmora/l10n/app_localizations.dart';
import 'package:velmora/services/subscription_plans_service.dart';
import 'package:velmora/services/subscription_service.dart';
import 'package:velmora/services/user_service.dart';
import 'package:velmora/utils/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:velmora/widgets/app_loading_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  final SubscriptionPlansService _plansService = SubscriptionPlansService();
  final UserService _userService = UserService();

  String? _selectedPlanId;
  bool _isLoading = true;
  bool _isPurchasing = false;
  List<SubscriptionPlan> _plans = [];
  bool _hasUsedTrial = false;
  bool _isTrialActive = false;
  bool _hasActiveSubscription = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _subscriptionService.initialize();
    try {
      final plans = await _plansService.getPlans();
      final hasUsedTrial = await _userService.hasUsedTrial();
      final isTrialActive = await _userService.isTrialActive();
      final hasActiveSubscription = await _subscriptionService
          .hasActiveSubscription();
      print('Loaded ${plans.length} plans from Firestore');
      for (var plan in plans) {
        print('Plan: ${plan.name} - \$${plan.pricePerMonth}/mo');
      }
      if (mounted) {
        setState(() {
          _plans = plans;
          _hasUsedTrial = hasUsedTrial;
          _isTrialActive = isTrialActive;
          _hasActiveSubscription = hasActiveSubscription;
          // Default select popular plan, or first active
          _selectedPlanId = plans.where((p) => p.isPopular).isNotEmpty
              ? plans.firstWhere((p) => p.isPopular).id
              : plans.isNotEmpty
              ? plans.first.id
              : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading plans: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context).translate('error_loading_plans')}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _startFreeTrial() async {
    if (_isPurchasing) return;
    setState(() => _isPurchasing = true);
    try {
      await UserService().startTrial();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).trialStarted),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context).error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  Future<void> _handlePayment() async {
    if (_isPurchasing || _selectedPlanId == null) return;
    setState(() => _isPurchasing = true);

    try {
      final plan = _plans.firstWhere((p) => p.id == _selectedPlanId);
      final success = await _subscriptionService.purchaseSubscription(
        plan.productId,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).translate('processing_subscription'),
            ),
            backgroundColor: AppColors.brandPurple,
          ),
        );
      } else if (!success && mounted) {
        throw Exception('Failed to initiate purchase. Please try again.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context).error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await _subscriptionService.restorePurchases();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).translate('checking_purchases'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context).translate('error_restoring_purchases')}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _requestCancellation() async {
    try {
      final userId = _userService.currentUserId;
      if (userId == null) return;

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'cancellationRequested': true,
        'cancellationRequestedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).translate(
                'cancellation_request_submitted_admin_will_review_it',
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context).error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFDFBFF),
        body: SubscriptionScreenSkeleton(),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFF),
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              // Header
              // IconButton(
              //   onPressed: () => Navigator.pop(context),
              //   icon: Icon(Icons.arrow_back, size: 24.adaptSize),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     // TextButton(
              //     //   onPressed: _restorePurchases,
              //     //   child: Text(
              //     //     AppLocalizations.of(context).restorePurchases,
              //     //     style: TextStyle(
              //     //       color: AppColors.brandPurple,
              //     //       fontSize: 14.fSize,
              //     //     ),
              //     //   ),
              //     // ),
              //   ],
              // ),
              // Trial Badge
              if (!_hasUsedTrial && !_isTrialActive)
                GestureDetector(
                  onTap: _isPurchasing ? null : _startFreeTrial,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB800), Color(0xFFFF6B00)],
                      ),
                      borderRadius: BorderRadius.circular(25.adaptSize),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 16.adaptSize,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          AppLocalizations.of(context).freeTrial48h,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.fSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20.h),
              Icon(
                Icons.workspace_premium_rounded,
                size: 76.adaptSize,
                color: AppColors.brandPurple,
              ),
              SizedBox(height: 16.h),
              Text(
                AppLocalizations.of(context).premiumAccess,
                style: TextStyle(
                  fontSize: 32.fSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2D1160),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                AppLocalizations.of(context).translate('choose_your_plan'),
                style: TextStyle(
                  fontSize: 16.fSize,
                  color: AppColors.brandPurple,
                ),
              ),
              SizedBox(height: 40.h),

              // Dynamic plan cards from Firestore
              if (_plans.isEmpty)
                Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.adaptSize,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).translate('no_plans_available'),
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16.fSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).translate('unable_to_load_subscription_plans'),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14.fSize,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _isLoading = true);
                        _initialize();
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(AppLocalizations.of(context).retry),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                )
              else
                ...(_plans.map(
                  (plan) => Column(
                    children: [
                      _buildPlanCard(plan: plan),
                      SizedBox(height: 16.h),
                    ],
                  ),
                )),

              SizedBox(height: 32.h),

              // Pay button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: (_isPurchasing || _selectedPlanId == null)
                      ? null
                      : _handlePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.adaptSize),
                    ),
                  ),
                  child: _isPurchasing
                      ? const AppCircularLoader(
                          size: 20,
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                      : Text(
                          AppLocalizations.of(context).translate('pay_now'),
                          style: TextStyle(
                            fontSize: 18.fSize,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              if (!_hasUsedTrial && !_isTrialActive)
                TextButton(
                  onPressed: _isPurchasing ? null : _startFreeTrial,
                  child: Text(
                    AppLocalizations.of(
                      context,
                    ).translate('or_start_48_hour_free_trial'),
                    style: TextStyle(
                      color: AppColors.brandPurple,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.fSize,
                    ),
                  ),
                ),
              SizedBox(height: 16.h),
              // Show bottomNote from the selected plan (Firestore-managed)
              Builder(
                builder: (_) {
                  // Get the cheapest plan price
                  final cheapestPrice = _plans.isNotEmpty
                      ? _plans
                            .map((p) => p.pricePerMonth)
                            .reduce((a, b) => a < b ? a : b)
                      : 4.99;

                  final selectedPlan = _selectedPlanId != null
                      ? _plans.where((p) => p.id == _selectedPlanId).firstOrNull
                      : null;
                  final note = (selectedPlan?.bottomNote?.isNotEmpty == true)
                      ? selectedPlan!.bottomNote!
                      : 'Free for 48 hours, then \$${cheapestPrice.toStringAsFixed(2)}/month. Cancel anytime.';
                  return Text(
                    note,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13.fSize,
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),

              // Cancel Request Button (only show if user has active subscription)
              if (_hasActiveSubscription)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _requestCancellation,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.adaptSize),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).translate('request_cancellation'),
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 14.fSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16.h),

              _buildFooterIconLabel(
                Icons.lock_outline,
                AppLocalizations.of(context).securePayment,
              ),
              SizedBox(height: 8.h),
              _buildFooterIconLabel(
                Icons.auto_awesome,
                AppLocalizations.of(context).noCommitment,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({required SubscriptionPlan plan}) {
    final isSelected = _selectedPlanId == plan.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlanId = plan.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.adaptSize),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.adaptSize),
          border: Border.all(
            color: isSelected ? AppColors.brandPurple : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Icon based on duration
                Container(
                  padding: EdgeInsets.all(10.adaptSize),
                  decoration: BoxDecoration(
                    color: _iconColor(plan.durationMonths),
                    borderRadius: BorderRadius.circular(12.adaptSize),
                  ),
                  child: Icon(
                    _planIcon(plan.durationMonths),
                    color: Colors.white,
                    size: 24.adaptSize,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            plan.name,
                            style: TextStyle(
                              fontSize: 15.fSize,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1F2933),
                            ),
                          ),
                          if (plan.badge != null && plan.badge!.isNotEmpty) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: _parseBadgeColor(plan.badgeColor),
                                borderRadius: BorderRadius.circular(
                                  6.adaptSize,
                                ),
                              ),
                              child: Text(
                                plan.badge!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.fSize,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '\$${plan.pricePerMonth.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 22.fSize,
                              fontWeight: FontWeight.w400,
                              color: AppColors.brandPurple,
                            ),
                          ),
                          Text(
                            '/mo',
                            style: TextStyle(
                              fontSize: 12.fSize,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 24.adaptSize,
                      height: 24.adaptSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.brandPurple
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.brandPurple
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16.adaptSize,
                            )
                          : null,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '\$${plan.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 11.fSize,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (plan.savingsText != null && plan.savingsText!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  plan.savingsText!,
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontSize: 11.fSize,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _planIcon(int months) {
    if (months >= 12) return Icons.workspace_premium;
    if (months >= 3) return Icons.trending_up_rounded;
    return Icons.electric_bolt_rounded;
  }

  Color _iconColor(int months) {
    if (months >= 12) return const Color(0xFFFF9F0A);
    if (months >= 3) return const Color(0xFFFF4B8D);
    return const Color(0xFFA267FF);
  }

  Color _parseBadgeColor(String? hex) {
    if (hex == null) return const Color(0xFFFF8A00);
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFFFF8A00);
    }
  }

  Widget _buildFooterIconLabel(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.black87, size: 16.adaptSize),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12.fSize),
        ),
      ],
    );
  }
}
