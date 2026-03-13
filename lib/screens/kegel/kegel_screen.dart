import 'package:velmora/screens/settings/subscription_screen.dart';
import 'package:velmora/services/subscription_service.dart';
import 'package:velmora/services/user_service.dart';
import 'package:velmora/l10n/app_localizations.dart';
import 'package:velmora/screens/kegel/kegel_challenge_screen.dart';
import 'package:velmora/screens/kegel/kegel_starting_screen.dart';
import 'package:velmora/services/kegel_service.dart';
import 'package:velmora/utils/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velmora/widgets/app_loading_widgets.dart';

class KegelScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const KegelScreen({super.key, this.onBackToHome});

  @override
  State<KegelScreen> createState() => _KegelScreenState();
}

class _KegelScreenState extends State<KegelScreen> {
  final KegelService _kegelService = KegelService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _kegelData;
  List<Map<String, dynamic>> _exercises = [];
  bool _isLoading = true;
  bool _showChallengeBanner = true;

  @override
  void initState() {
    super.initState();
    _loadKegelData();
  }

  Future<void> _loadKegelData() async {
    try {
      final data = await _kegelService.getKegelData();
      final exercises = await _loadExercises();
      if (mounted) {
        setState(() {
          _kegelData = data;
          _exercises = exercises;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<List<Map<String, dynamic>>> _loadExercises() async {
    try {
      // Load exercises from Firestore
      final exercisesSnapshot = await _firestore
          .collection('kegel_exercises')
          .get();

      List<Map<String, dynamic>> exercises = [];

      for (var doc in exercisesSnapshot.docs) {
        final data = doc.data();
        exercises.add({
          'id': doc.id,
          'name': data['name'] ?? 'Exercise',
          'duration': data['duration'] ?? 5,
          'sets': data['sets'] ?? 3,
          'isPremium': data['isPremium'] ?? false,
          'isActive': data['isActive'] ?? true,
        });
      }

      // If no exercises in Firestore, use defaults
      if (exercises.isEmpty) {
        exercises = _getDefaultExercises();
      }

      // Filter out inactive exercises
      exercises = exercises.where((e) => e['isActive'] == true).toList();

      return exercises;
    } catch (e) {
      // If Firestore fails, use defaults
      return _getDefaultExercises();
    }
  }

  List<Map<String, dynamic>> _getDefaultExercises() {
    return [
      {
        'id': 'beginner',
        'name': 'Beginner Routine',
        'duration': 5,
        'sets': 3,
        'isPremium': false,
        'isActive': true,
      },
      {
        'id': 'intermediate',
        'name': 'Intermediate Routine',
        'duration': 10,
        'sets': 5,
        'isPremium': false,
        'isActive': true,
      },
      {
        'id': 'advanced',
        'name': 'Advanced Routine',
        'duration': 15,
        'sets': 7,
        'isPremium': false,
        'isActive': true,
      },
    ];
  }

  Future<void> _navigateToKegelStartingScreen(
    String routineType,
    int durationMinutes,
    int sets,
    bool isPremium,
  ) async {
    if (isPremium) {
      final hasAccess =
          await SubscriptionService().hasActiveSubscription() ||
          await UserService().isTrialActive();

      if (!hasAccess && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PremiumScreen()),
        );
        return;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KegelStartingScreen(
          routineType: routineType,
          durationMinutes: durationMinutes,
          sets: sets,
        ),
      ),
    ).then((_) => _loadKegelData());
  }

  int get _weekStreak => _kegelData?['weekStreak'] ?? 0;
  int get _totalCompleted => _kegelData?['totalCompleted'] ?? 0;
  double get _dailyGoalPercent =>
      (_kegelData?['dailyGoalPercent'] ?? 0.0).toDouble();

  Color _getExerciseColor(String exerciseId) {
    switch (exerciseId) {
      case 'beginner':
        return const Color(0xFF4CAF50);
      case 'intermediate':
        return const Color(0xFF9B67FF);
      case 'advanced':
        return const Color(0xFFFF4D8D);
      default:
        return const Color(0xFF6B26FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildHeader(context),
                Positioned(
                  bottom: -190.h,
                  left: 20.w,
                  right: 20.w,
                  child: _buildProgressCard(),
                ),
              ],
            ),
            RefreshIndicator(
              onRefresh: _loadKegelData,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 220.h),
                    if (_showChallengeBanner) _buildChallengePromoCard(),
                    SizedBox(height: 24.h),
                    Text(
                      AppLocalizations.of(context).exerciseRoutines,
                      style: TextStyle(
                        fontSize: 18.fSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (_isLoading)
                      const KegelScreenSkeleton()
                    else if (_exercises.isEmpty)
                      Center(
                        child: Text(
                          AppLocalizations.of(context).noExercisesAvailable,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      ..._exercises.map(
                        (exercise) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildRoutineCard(
                            title: exercise['name'],
                            subtitle:
                                '${exercise['duration']} ${AppLocalizations.of(context).minutes} • ${exercise['sets']} ${AppLocalizations.of(context).sets}',
                            iconBg: _getExerciseColor(exercise['id']),
                            playBtnColor: const Color(0xFF6B26FF),
                            isPremium: exercise['isPremium'] ?? false,
                            onTap: () => _navigateToKegelStartingScreen(
                              exercise['name'],
                              exercise['duration'],
                              exercise['sets'],
                              exercise['isPremium'] ?? false,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 24.h),
                    _buildInfoCard(
                      icon: Icons.info_outline,
                      bgColor: const Color.fromARGB(255, 246, 241, 255),
                      iconBg: const Color(0xFF9B67FF),
                      title: AppLocalizations.of(context).aboutKegel,
                      content: AppLocalizations.of(context).aboutKegelContent,
                    ),
                    SizedBox(height: 12.h),
                    _buildInfoCard(
                      icon: Icons.female,
                      iconBg: const Color(0xFFFF4D8D),
                      title: AppLocalizations.of(context).targetMuscle,
                      content: AppLocalizations.of(context).targetMuscleContent,
                    ),
                    SizedBox(height: 12.h),
                    _buildHowToPerformCard(),
                    SizedBox(height: 12.h),
                    _buildTipsCard(),
                    SizedBox(height: 12.h),
                    _buildDisclaimerCard(),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9B67FF), Color(0xFF6B26FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.onBackToHome != null) {
                    widget.onBackToHome!();
                    return;
                  }
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24.adaptSize,
                ),
              ),
              SizedBox(width: 12.w),
              Icon(Icons.bolt, color: Colors.white, size: 28.adaptSize),
              SizedBox(width: 8.w),
              Text(
                AppLocalizations.of(context).kegel,
                style: TextStyle(
                  fontSize: 24.fSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(context).intimateWellnessJourney,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.fSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: EdgeInsets.all(20.adaptSize),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.adaptSize),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).yourProgress,
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.adaptSize),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8F0),
                    borderRadius: BorderRadius.circular(12.adaptSize),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 20.adaptSize,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            AppLocalizations.of(context).weekStreak,
                            style: TextStyle(
                              fontSize: 12.fSize,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "$_weekStreak",
                        style: TextStyle(
                          fontSize: 24.fSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.adaptSize),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FFF4),
                    borderRadius: BorderRadius.circular(12.adaptSize),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 20.adaptSize,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            AppLocalizations.of(context).completedLabel,
                            style: TextStyle(
                              fontSize: 12.fSize,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "$_totalCompleted",
                        style: TextStyle(
                          fontSize: 24.fSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).dailyGoal,
                style: TextStyle(fontSize: 12.fSize, color: Colors.black54),
              ),
              Text(
                "${_dailyGoalPercent.toInt()}%",
                style: TextStyle(fontSize: 12.fSize, color: Colors.black54),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_dailyGoalPercent / 100).clamp(0.0, 1.0),
              minHeight: 6.h,
              backgroundColor: const Color(0xFF9B67FF).withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF9B67FF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCard({
    required String title,
    required String subtitle,
    required Color iconBg,
    required Color playBtnColor,
    required VoidCallback onTap,
    bool isPremium = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.adaptSize),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.adaptSize),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12.adaptSize),
              ),
              child: Icon(
                Icons.emoji_events_outlined,
                color: Colors.white,
                size: 28.adaptSize,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16.fSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (isPremium) ...[
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.workspace_premium,
                          color: const Color(0xFFFFD700),
                          size: 20.adaptSize,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13.fSize, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: playBtnColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 20.adaptSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String content,
    Color bgColor = Colors.white,
  }) {
    return Container(
      padding: EdgeInsets.all(20.adaptSize),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.adaptSize),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.adaptSize),
                decoration: BoxDecoration(
                  color: iconBg,
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(11.adaptSize),
                ),
                child: Icon(icon, color: Colors.white, size: 24.adaptSize),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 13.fSize,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToPerformCard() {
    return Container(
      padding: EdgeInsets.all(20.adaptSize),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.adaptSize),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.adaptSize),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B67FF),
                  borderRadius: BorderRadius.circular(11.adaptSize),
                ),
                child: Icon(
                  Icons.menu_book,
                  color: Colors.white,
                  size: 24.adaptSize,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                AppLocalizations.of(context).howToPerform,
                style: TextStyle(
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildStep(
            number: '1',
            title: AppLocalizations.of(context).step1Title,
            desc: AppLocalizations.of(context).step1Desc,
            color: const Color(0xFF4CAF50),
          ),
          _buildStep(
            number: '2',
            title: AppLocalizations.of(context).step2Title,
            desc: AppLocalizations.of(context).step2Desc,
            color: const Color(0xFFFF4D8D),
          ),
          _buildStep(
            number: '3',
            title: AppLocalizations.of(context).step3Title,
            desc: AppLocalizations.of(context).step3Desc,
            color: const Color(0xFF9B67FF),
          ),
          _buildStep(
            number: '4',
            title: AppLocalizations.of(context).step4Title,
            desc: AppLocalizations.of(context).step4Desc,
            color: const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String desc,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$number. $title',
                  style: TextStyle(
                    fontSize: 14.fSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13.fSize,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: EdgeInsets.all(20.adaptSize),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16.adaptSize),
        border: Border.all(color: const Color.fromARGB(255, 234, 234, 234)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.adaptSize),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 228, 137, 1),
                  borderRadius: BorderRadius.circular(11.adaptSize),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 24.adaptSize,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                AppLocalizations.of(context).importantTips,
                style: TextStyle(
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildTip(AppLocalizations.of(context).tip1),
          _buildTip(AppLocalizations.of(context).tip2),
          _buildTip(AppLocalizations.of(context).tip3),
          _buildTip(AppLocalizations.of(context).tip4),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 13.fSize,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 13.fSize,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
      padding: EdgeInsets.all(20.adaptSize),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16.adaptSize),
        border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: const Color.fromARGB(255, 228, 137, 1),
            size: 24.adaptSize,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).medicalDisclaimer,
                  style: TextStyle(
                    fontSize: 14.fSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 228, 137, 1),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppLocalizations.of(context).medicalDisclaimerContent,
                  style: TextStyle(
                    fontSize: 12.fSize,
                    color: const Color.fromARGB(255, 228, 137, 1),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengePromoCard() {
    final l10n = AppLocalizations.of(context);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const KegelChallengeScreen(),
              ),
            ).then((_) => _loadKegelData());
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.adaptSize),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.adaptSize),
              gradient: const LinearGradient(
                colors: [Color(0xFF6B26FF), Color(0xFF9B67FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B26FF).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '30 DAYS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.fSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        l10n.kegelChallenge,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.fSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        l10n.kegelChallengeSubtitle,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.fSize,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Text(
                            l10n.viewChallenge,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.fSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80.adaptSize,
                      height: 80.adaptSize,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 40.adaptSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showChallengeBanner = false;
              });
            },
            child: Container(
              padding: EdgeInsets.all(4.adaptSize),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 18.adaptSize),
            ),
          ),
        ),
      ],
    );
  }
}
