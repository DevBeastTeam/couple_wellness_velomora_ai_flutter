import 'package:velmora/constants/app_colors.dart';
import 'package:velmora/screens/settings/subscription_screen.dart';
import 'package:velmora/services/subscription_service.dart';
import 'package:velmora/services/user_service.dart';
import 'package:velmora/utils/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget that displays the user's current subscription status
class SubscriptionStatusWidget extends StatelessWidget {
  const SubscriptionStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getSubscriptionStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        final status = snapshot.data;
        if (status == null) return const SizedBox.shrink();

        return _buildStatusCard(context, status);
      },
    );
  }

  Future<Map<String, dynamic>> _getSubscriptionStatus() async {
    final subscriptionService = SubscriptionService();
    final userService = UserService();

    // Check for active subscription
    final subscriptionInfo = await subscriptionService.getSubscriptionInfo();
    if (subscriptionInfo != null && subscriptionInfo['isPremium'] == true) {
      return {
        'type': 'premium',
        'subscriptionType': subscriptionInfo['subscriptionType'],
        'expiryDate': subscriptionInfo['expiryDate'],
      };
    }

    // Check for active trial
    final isTrialActive = await userService.isTrialActive();
    if (isTrialActive) {
      final trialRemaining = await userService.getTrialTimeRemaining();
      return {'type': 'trial', 'timeRemaining': trialRemaining};
    }

    // Free user
    return {'type': 'free'};
  }

  Widget _buildStatusCard(BuildContext context, Map<String, dynamic> status) {
    final type = status['type'] as String;

    if (type == 'free') {
      return _buildFreeCard(context);
    } else if (type == 'trial') {
      return _buildTrialCard(context, status);
    } else {
      return _buildPremiumCard(context, status);
    }
  }

  Widget _buildFreeCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PremiumScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        padding: EdgeInsets.all(16.adaptSize),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B42FF), Color(0xFFB042FF)],
          ),
          borderRadius: BorderRadius.circular(16.adaptSize),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPurple.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 32.adaptSize,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Free Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.fSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Upgrade to unlock all features',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13.fSize,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16.adaptSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrialCard(BuildContext context, Map<String, dynamic> status) {
    final timeRemaining = status['timeRemaining'] as Duration?;
    final hoursRemaining = timeRemaining?.inHours ?? 0;
    final minutesRemaining = (timeRemaining?.inMinutes ?? 0) % 60;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      padding: EdgeInsets.all(16.adaptSize),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB800), Color(0xFFFF6B00)],
        ),
        borderRadius: BorderRadius.circular(16.adaptSize),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB800).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.white, size: 32.adaptSize),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Free Trial Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${hoursRemaining}h ${minutesRemaining}m remaining',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13.fSize,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.white, size: 24.adaptSize),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context, Map<String, dynamic> status) {
    final subscriptionType = status['subscriptionType'] as String?;
    final expiryDate = status['expiryDate'] as DateTime?;

    String planName = 'Premium';
    if (subscriptionType != null) {
      if (subscriptionType.contains('monthly')) {
        planName = 'Monthly Premium';
      } else if (subscriptionType.contains('quarterly')) {
        planName = 'Quarterly Premium';
      } else if (subscriptionType.contains('yearly')) {
        planName = 'Yearly Premium';
      }
    }

    String expiryText = '';
    if (expiryDate != null) {
      expiryText = 'Expiry: ${DateFormat('MMM dd, yyyy').format(expiryDate)}';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      padding: EdgeInsets.all(16.adaptSize),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.circular(16.adaptSize),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified, color: Colors.white, size: 32.adaptSize),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  planName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.check_circle, color: Colors.white, size: 24.adaptSize),
            ],
          ),
          if (expiryText.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              expiryText,
              style: TextStyle(color: Colors.grey.shade300, fontSize: 12.fSize),
            ),
          ],
        ],
      ),
    );
  }
}
