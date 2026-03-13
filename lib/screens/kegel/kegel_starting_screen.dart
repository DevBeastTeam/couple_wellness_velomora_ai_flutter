import 'dart:async';
import 'package:velmora/l10n/app_localizations.dart';
import 'package:velmora/services/kegel_service.dart';
import 'package:velmora/utils/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class KegelStartingScreen extends StatefulWidget {
  final String routineType;
  final int durationMinutes;
  final int sets;

  const KegelStartingScreen({
    super.key,
    this.routineType = "Beginner Routine",
    this.durationMinutes = 5,
    this.sets = 3,
  });

  @override
  State<KegelStartingScreen> createState() => _KegelStartingScreenState();
}

class _KegelStartingScreenState extends State<KegelStartingScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  int _currentSet = 1;
  int _currentPhase =
      1; // 1: Hold & Squeeze, 2: Rest & Relax, 3: Rest Between Sets
  bool _isPlaying = false;
  bool _isCompleted = false;

  // Timing configuration
  final int _holdSqueezeSeconds = 3;
  final int _restRelaxSeconds = 3;
  final int _restBetweenSetsSeconds = 30;
  int _phaseSeconds = 0;
  int _cycleCount = 0; // Track cycles within a set
  late int _cyclesPerSet; // Fixed based on routine type

  final KegelService _kegelService = KegelService();

  @override
  void initState() {
    super.initState();
    _phaseSeconds = _holdSqueezeSeconds;
    _currentPhase = 1;
    // Set cycles per set based on routine type
    // Beginner: 10 dots, Intermediate: 15 dots, Advanced: 20 dots
    if (widget.durationMinutes == 5) {
      _cyclesPerSet = 10; // Beginner
    } else if (widget.durationMinutes == 8) {
      _cyclesPerSet = 15; // Intermediate
    } else if (widget.durationMinutes == 12) {
      _cyclesPerSet = 20; // Advanced
    } else {
      _cyclesPerSet = 10; // Default
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        _elapsedSeconds++;
        _phaseSeconds--;

        if (_phaseSeconds <= 0) {
          _togglePhase();
        }

        final totalSeconds = widget.durationMinutes * 60;
        if (_elapsedSeconds >= totalSeconds) {
          _completeExercise();
        }
      });
    });
  }

  void _togglePhase() {
    if (_currentPhase == 1) {
      // From Hold & Squeeze to Rest & Relax
      _currentPhase = 2;
      _phaseSeconds = _restRelaxSeconds;
    } else if (_currentPhase == 2) {
      // From Rest & Relax back to Hold & Squeeze or Rest Between Sets
      _cycleCount++;

      // After completing cycles per set, take 30 second rest between sets
      if (_cycleCount >= _cyclesPerSet) {
        // Time for rest between sets (only if not on last set)
        if (_currentSet < widget.sets) {
          _currentPhase = 3;
          _phaseSeconds = _restBetweenSetsSeconds;
          _cycleCount = 0;
          _currentSet++;
        } else {
          // Last set completed - finish exercise
          _completeExercise();
          return;
        }
      } else {
        // Continue with next cycle
        _currentPhase = 1;
        _phaseSeconds = _holdSqueezeSeconds;
      }
    } else if (_currentPhase == 3) {
      // From Rest Between Sets back to Hold & Squeeze
      _currentPhase = 1;
      _phaseSeconds = _holdSqueezeSeconds;
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _completeExercise() {
    _timer?.cancel();
    setState(() {
      _isCompleted = true;
      _isPlaying = false;
    });
    _kegelService.saveSession(
      routineType: widget.routineType,
      durationMinutes: widget.durationMinutes,
      setsCompleted: _currentSet > widget.sets ? widget.sets : _currentSet,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted) {
      final l10n = AppLocalizations.of(context);
      return Scaffold(
        body: Stack(
          children: [
            // Pink/Magenta Gradient Header
            Container(
              width: double.infinity,
              height: 300.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF5B88), Color(0xFFFF5277)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    widget.routineType,
                    style: TextStyle(
                      fontSize: 24.fSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "${l10n.set} $_currentSet ${l10n.ofLabel} ${widget.sets}",
                    style: TextStyle(
                      fontSize: 16.fSize,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // White Card
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.adaptSize),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Checkmark Circle
                    Container(
                      width: 100.adaptSize,
                      height: 100.adaptSize,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF5B88), Color(0xFFFF5277)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF5277).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 50.adaptSize,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      l10n.greatJob,
                      style: TextStyle(
                        fontSize: 28.fSize,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "${l10n.youCompleted} ${widget.sets} ${l10n.setsCompleted} (60 reps)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.fSize,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    // Finish Button
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9B3BFF), // Purple
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.adaptSize),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.finish,
                          style: TextStyle(
                            fontSize: 18.fSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final totalSeconds = widget.durationMinutes * 60;
    final progressVal = (_elapsedSeconds / totalSeconds).clamp(0.0, 1.0);

    Widget circleContent = Container(
      width: 220.adaptSize,
      height: 220.adaptSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _currentPhase == 1
              ? const Color(0xFF8B3DFF) // Purple for Hold & Squeeze
              : _currentPhase == 2
              ? const Color(0xFF13D187) // Green for Rest & Relax
              : const Color(0xFFFF9800), // Orange for Rest Between Sets
          width: 10.adaptSize,
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$_phaseSeconds",
            style: TextStyle(
              fontSize: 64.fSize,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111827),
            ),
          ),
          Text(
            "SECONDS",
            style: TextStyle(
              fontSize: 12.fSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );

    if (_isPlaying) {
      circleContent = circleContent
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scaleXY(
            begin: 0.9,
            end: 1.1,
            duration: 1.seconds,
            curve: Curves.easeInOut,
          );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          // Dynamic Background Color based on phase
          AnimatedContainer(
            height: 300.h,
            width: double.infinity,
            duration: const Duration(milliseconds: 300),
            color: _currentPhase == 2
                ? const Color(0xFF13D187) // Green for Rest & Relax
                : _currentPhase == 3
                ? const Color(0xFFFF9800) // Orange for Rest Between Sets
                : const Color(0xFF8B3DFF), // Purple for Hold & Squeeze
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 10.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.adaptSize,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  widget.routineType,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.fSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Set ${_currentSet > widget.sets ? widget.sets : _currentSet} of ${widget.sets}",
                  // "${widget.sets} times repetition",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.fSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30.h),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      bottom: 40.h,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.adaptSize),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 48.h),
                          // Big Timer Circle
                          circleContent,
                          SizedBox(height: 40.h),
                          Text(
                            _currentPhase == 1
                                ? "Hold & Squeeze"
                                : _currentPhase == 2
                                ? "Rest & Relax"
                                : "Rest Between Sets",
                            style: TextStyle(
                              fontSize: 24.fSize,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          // Cycle Dots Indicator (dynamic based on routine)
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 6.w,
                            runSpacing: 8.h,
                            children: List.generate(_cyclesPerSet, (index) {
                              bool isCompleted = index < _cycleCount;
                              bool isCurrent =
                                  index == _cycleCount && _currentPhase <= 2;
                              return Container(
                                width: 10.adaptSize,
                                height: 10.adaptSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCompleted
                                      ? const Color(
                                          0xFF8B3DFF,
                                        ) // Purple for completed
                                      : isCurrent
                                      ? _currentPhase == 1
                                            ? const Color(
                                                0xFF8B3DFF,
                                              ) // Purple for Hold & Squeeze
                                            : const Color(
                                                0xFF13D187,
                                              ) // Green for Rest & Relax
                                      : const Color(0xFFE5E7EB),
                                  border: isCurrent
                                      ? Border.all(
                                          color: _currentPhase == 1
                                              ? const Color(
                                                  0xFF8B3DFF,
                                                ) // Purple border for Hold
                                              : const Color(
                                                  0xFF13D187,
                                                ), // Green border for Rest
                                          width: 2,
                                        )
                                      : null,
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 8.h),
                          // Text(
                          //   "Cycle ${_cycleCount + 1} of $_cyclesPerSet",
                          //   style: TextStyle(
                          //     fontSize: 12.fSize,
                          //     color: Colors.grey.shade600,
                          //   ),
                          // ),
                          SizedBox(height: 32.h),
                          // Resume/Pause Button
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B3DFF),
                                  borderRadius: BorderRadius.circular(
                                    16.adaptSize,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow_outlined,
                                      color: Colors.white,
                                      size: 20.adaptSize,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      _isPlaying ? "Pause" : "Resume",
                                      style: TextStyle(
                                        fontSize: 16.fSize,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          // Overall Progress Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Overall Progress",
                                  style: TextStyle(
                                    fontSize: 13.fSize,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF4B5563),
                                  ),
                                ),
                                Text(
                                  "${(progressVal * 100).toInt()}%",
                                  style: TextStyle(
                                    fontSize: 13.fSize,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 6.adaptSize,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE5E7EB),
                                    borderRadius: BorderRadius.circular(
                                      3.adaptSize,
                                    ),
                                  ),
                                ),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final progressWidth =
                                        constraints.maxWidth * progressVal;
                                    return Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        Container(
                                          width: progressWidth,
                                          height: 6.adaptSize,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF8B3DFF),
                                            borderRadius: BorderRadius.circular(
                                              3.adaptSize,
                                            ),
                                          ),
                                        ),
                                        if (progressWidth > 0)
                                          Positioned(
                                            left: progressWidth - 5.adaptSize,
                                            child: Container(
                                              width: 10.adaptSize,
                                              height: 10.adaptSize,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xFF8B3DFF),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
