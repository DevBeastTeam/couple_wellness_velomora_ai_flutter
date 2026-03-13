import 'package:velmora/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────

Widget _sBox(Color c, double h, double r) => Container(
  height: h,
  decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(r)),
);

Widget _line({double height = 13, double widthFactor = 1, Color? color}) =>
    FractionallySizedBox(
      widthFactor: widthFactor,
      child: _sBox(color ?? Colors.grey.shade300, height, 8),
    );

Widget _card({
  required Widget child,
  EdgeInsets? padding,
  Color? color,
  double radius = 16,
}) => Container(
  padding: padding ?? const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: color ?? Colors.grey.shade200,
    borderRadius: BorderRadius.circular(radius),
  ),
  child: child,
);

Widget _shimmerWrap(Widget child) => child
    .animate(onPlay: (c) => c.repeat())
    .shimmer(duration: 1200.ms, color: AppColors.brandPurple.withOpacity(0.09));

// ─────────────────────────────────────────────
// Branded circular loader
// ─────────────────────────────────────────────

class AppCircularLoader extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const AppCircularLoader({
    super.key,
    this.size = 32,
    this.strokeWidth = 3,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.brandPurple,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Generic fallback skeleton (3 cards)
// ─────────────────────────────────────────────

class AppPageSkeleton extends StatelessWidget {
  const AppPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      ListView(
        padding: const EdgeInsets.all(20),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _line(height: 22, widthFactor: 0.5),
          const SizedBox(height: 20),
          _rowCard(),
          const SizedBox(height: 14),
          _rowCard(),
          const SizedBox(height: 14),
          _rowCard(),
          const SizedBox(height: 14),
          _rowCard(),
        ],
      ),
    );
  }

  Widget _rowCard() => _card(
    child: Row(
      children: [
        _sBox(Colors.grey.shade300, 44, 12),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line(height: 14, widthFactor: 0.6),
              const SizedBox(height: 8),
              _line(height: 12, widthFactor: 0.9),
            ],
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────
// Home Screen Skeleton
// ─────────────────────────────────────────────

class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      Column(
        children: [
          // Purple header block
          Container(
            height: 260,
            color: Colors.grey.shade300,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(height: 18, widthFactor: 0.45),
                const SizedBox(height: 12),
                _line(height: 28, widthFactor: 0.65),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _sBox(Colors.grey.shade400, 32, 20),
                    const SizedBox(width: 8),
                    _sBox(Colors.grey.shade400, 32, 20),
                    const SizedBox(width: 8),
                    _sBox(Colors.grey.shade400, 32, 20),
                  ],
                ),
              ],
            ),
          ),
          // Floating card
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: _card(
              color: Colors.white,
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  _sBox(Colors.grey.shade300, 44, 12),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _line(height: 14, widthFactor: 0.55),
                        const SizedBox(height: 8),
                        _line(height: 12, widthFactor: 0.75),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Feature list cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _featureCard(),
                const SizedBox(height: 14),
                _featureCard(),
                const SizedBox(height: 14),
                _featureCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard() => _card(
    color: Colors.white,
    padding: const EdgeInsets.all(18),
    child: Row(
      children: [
        _sBox(Colors.grey.shade300, 48, 14),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line(height: 15, widthFactor: 0.5),
              const SizedBox(height: 8),
              _line(height: 12, widthFactor: 0.85),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _sBox(Colors.grey.shade300, 20, 10),
      ],
    ),
  );
}

// ─────────────────────────────────────────────
// Games Screen Skeleton
// ─────────────────────────────────────────────

class GamesScreenSkeleton extends StatelessWidget {
  const GamesScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      Column(
        children: [
          // Pink header
          Container(
            height: 200,
            color: Colors.grey.shade300,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(height: 22, widthFactor: 0.55),
                const SizedBox(height: 10),
                _line(height: 14, widthFactor: 0.75),
              ],
            ),
          ),
          // Game cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _gameCard(),
                const SizedBox(height: 16),
                _gameCard(),
                const SizedBox(height: 16),
                _gameCard(),
                const SizedBox(height: 16),
                _gameCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gameCard() => _card(
    padding: EdgeInsets.zero,
    color: Colors.white,
    radius: 20,
    child: Column(
      children: [
        // Colored banner top
        Container(
          height: 130,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          alignment: Alignment.center,
          child: _sBox(Colors.grey.shade400, 60, 30),
        ),
        // Detail body
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line(height: 16, widthFactor: 0.6),
              const SizedBox(height: 8),
              _line(height: 12, widthFactor: 0.95),
              const SizedBox(height: 6),
              _line(height: 12, widthFactor: 0.75),
              const SizedBox(height: 14),
              _sBox(Colors.grey.shade300, 40, 12),
            ],
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────
// Kegel Screen Skeleton
// ─────────────────────────────────────────────

class KegelScreenSkeleton extends StatelessWidget {
  const KegelScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // Gradient header
            Container(
              height: 180,
              color: Colors.grey.shade300,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(height: 22, widthFactor: 0.55),
                  const SizedBox(height: 10),
                  _line(height: 13, widthFactor: 0.7),
                ],
              ),
            ),
            // Floating progress card
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: _card(
                color: Colors.white,
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _line(height: 14, widthFactor: 0.45),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _statBox()),
                        const SizedBox(width: 12),
                        Expanded(child: _statBox()),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _sBox(Colors.grey.shade300, 10, 8),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Promo banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _card(
                color: Colors.grey.shade300,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _line(height: 15, widthFactor: 0.55),
                          const SizedBox(height: 8),
                          _line(height: 12, widthFactor: 0.8),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _sBox(Colors.grey.shade400, 50, 25),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Section title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _line(height: 16, widthFactor: 0.45),
            ),
            const SizedBox(height: 14),
            // 3 routine cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _routineCard(),
                  const SizedBox(height: 12),
                  _routineCard(),
                  const SizedBox(height: 12),
                  _routineCard(),
                  const SizedBox(height: 20),
                  _infoBlock(),
                  const SizedBox(height: 12),
                  _infoBlock(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox() => _card(
    color: Colors.grey.shade200,
    padding: const EdgeInsets.all(14),
    child: Column(
      children: [
        _sBox(Colors.grey.shade300, 24, 12),
        const SizedBox(height: 8),
        _line(height: 18, widthFactor: 0.4),
        const SizedBox(height: 6),
        _line(height: 11, widthFactor: 0.65),
      ],
    ),
  );

  Widget _routineCard() => _card(
    color: Colors.white,
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        _sBox(Colors.grey.shade300, 48, 14),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line(height: 14, widthFactor: 0.5),
              const SizedBox(height: 7),
              _line(height: 12, widthFactor: 0.8),
            ],
          ),
        ),
        _sBox(Colors.grey.shade300, 40, 20),
      ],
    ),
  );

  Widget _infoBlock() => _card(
    color: Colors.grey.shade200,
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _line(height: 15, widthFactor: 0.4),
        const SizedBox(height: 10),
        _line(height: 12, widthFactor: 1),
        const SizedBox(height: 7),
        _line(height: 12, widthFactor: 0.85),
      ],
    ),
  );
}

// ─────────────────────────────────────────────
// Kegel Achievements Screen Skeleton
// ─────────────────────────────────────────────

class KegelAchievementsSkeleton extends StatelessWidget {
  const KegelAchievementsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      ListView(
        padding: const EdgeInsets.all(20),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Stat row
          Row(
            children: [
              Expanded(child: _statCard()),
              const SizedBox(width: 14),
              Expanded(child: _statCard()),
            ],
          ),
          const SizedBox(height: 18),
          // Weekly chart card
          _card(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(height: 15, widthFactor: 0.35),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (i) => _barItem(i)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _line(height: 16, widthFactor: 0.4),
          const SizedBox(height: 14),
          // 6 achievement rows
          ...List.generate(
            6,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _achievementRow(),
            ),
          ),
          // 30-day plan card
          _card(
            color: Colors.grey.shade200,
            radius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(height: 16, widthFactor: 0.5),
                const SizedBox(height: 10),
                _line(height: 12, widthFactor: 0.8),
                const SizedBox(height: 14),
                _sBox(Colors.grey.shade300, 10, 8),
                const SizedBox(height: 14),
                ...List.generate(
                  4,
                  (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _weekRow(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard() => _card(
    color: Colors.white,
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        _sBox(Colors.grey.shade300, 36, 18),
        const SizedBox(height: 10),
        _line(height: 20, widthFactor: 0.4),
        const SizedBox(height: 6),
        _line(height: 12, widthFactor: 0.65),
      ],
    ),
  );

  Widget _barItem(int i) {
    final heights = [40.0, 60.0, 30.0, 80.0, 50.0, 70.0, 45.0];
    return Column(
      children: [
        _sBox(Colors.grey.shade300, heights[i], 6),
        const SizedBox(height: 4),
        _sBox(Colors.grey.shade300, 12, 4),
      ],
    );
  }

  Widget _achievementRow() => _card(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(
      children: [
        _sBox(Colors.grey.shade300, 50, 12),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line(height: 14, widthFactor: 0.55),
              const SizedBox(height: 8),
              _line(height: 12, widthFactor: 0.85),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _sBox(Colors.grey.shade300, 24, 12),
      ],
    ),
  );

  Widget _weekRow() => _card(
    color: Colors.grey.shade300,
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [
        _sBox(Colors.grey.shade400, 40, 10),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line(height: 13, widthFactor: 0.55),
              const SizedBox(height: 6),
              _line(height: 11, widthFactor: 0.8),
            ],
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────
// Account / Profile Screen Skeleton
// ─────────────────────────────────────────────

class AccountScreenSkeleton extends StatelessWidget {
  const AccountScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      Column(
        children: [
          // Header
          Container(
            height: 180,
            color: Colors.grey.shade300,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
            child: _line(height: 26, widthFactor: 0.4),
          ),
          // Form card
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _card(
                  color: Colors.white,
                  radius: 20,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Avatar circle
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFFE0E0E0),
                      ),
                      const SizedBox(height: 24),
                      // 3 text fields
                      _fieldSkeleton(),
                      const SizedBox(height: 16),
                      _fieldSkeleton(),
                      const SizedBox(height: 16),
                      _fieldSkeleton(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _sBox(Colors.grey.shade300, 52, 14),
                const SizedBox(height: 14),
                _sBox(Colors.grey.shade200, 52, 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldSkeleton() => _card(
    color: Colors.grey.shade200,
    radius: 12,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    child: _line(height: 14, widthFactor: 0.6),
  );
}

// ─────────────────────────────────────────────
// Notifications Screen Skeleton
// ─────────────────────────────────────────────

class NotificationsScreenSkeleton extends StatelessWidget {
  const NotificationsScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      Column(
        children: [
          // Header
          Container(
            height: 180,
            color: Colors.grey.shade300,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
            child: _line(height: 26, widthFactor: 0.5),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                5,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _notifCard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notifCard() => _card(
    color: Colors.white,
    radius: 20,
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sBox(Colors.grey.shade300, 48, 24),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _line(height: 15, widthFactor: 0.65)),
                  const SizedBox(width: 8),
                  _sBox(Colors.grey.shade300, 24, 8),
                ],
              ),
              const SizedBox(height: 8),
              _line(height: 12, widthFactor: 0.95),
              const SizedBox(height: 6),
              _line(height: 12, widthFactor: 0.7),
              const SizedBox(height: 8),
              _line(height: 11, widthFactor: 0.3),
            ],
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────
// Subscription / Premium Screen Skeleton
// ─────────────────────────────────────────────

class SubscriptionScreenSkeleton extends StatelessWidget {
  const SubscriptionScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      ListView(
        padding: const EdgeInsets.all(24),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          // Badge
          Center(child: _sBox(Colors.grey.shade300, 34, 20)),
          const SizedBox(height: 24),
          // Big icon
          Center(child: _sBox(Colors.grey.shade300, 76, 38)),
          const SizedBox(height: 20),
          _line(height: 28, widthFactor: 0.6),
          const SizedBox(height: 10),
          _line(height: 14, widthFactor: 0.75),
          const SizedBox(height: 28),
          // 3 plan cards
          _planCard(),
          const SizedBox(height: 12),
          _planCard(),
          const SizedBox(height: 12),
          _planCard(),
          const SizedBox(height: 24),
          // Pay button
          _sBox(Colors.grey.shade300, 56, 16),
          const SizedBox(height: 14),
          Center(child: _line(height: 12, widthFactor: 0.55)),
          const SizedBox(height: 24),
          // Footer labels
          _footerRow(),
          const SizedBox(height: 10),
          _footerRow(),
        ],
      ),
    );
  }

  Widget _planCard() => _card(
    color: Colors.white,
    radius: 20,
    padding: const EdgeInsets.all(18),
    child: Row(
      children: [
        _sBox(Colors.grey.shade300, 44, 12),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line(height: 15, widthFactor: 0.55),
              const SizedBox(height: 8),
              _line(height: 12, widthFactor: 0.4),
            ],
          ),
        ),
        _sBox(Colors.grey.shade300, 24, 12),
      ],
    ),
  );

  Widget _footerRow() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _sBox(Colors.grey.shade300, 16, 8),
      const SizedBox(width: 10),
      _line(height: 12, widthFactor: 0.35),
    ],
  );
}

// ─────────────────────────────────────────────
// Privacy & Security Screen Skeleton
// ─────────────────────────────────────────────

class PrivacySecuritySkeleton extends StatelessWidget {
  const PrivacySecuritySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      Column(
        children: [
          Container(
            height: 200,
            color: Colors.grey.shade300,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
            child: _line(height: 28, widthFactor: 0.55),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _card(
                  color: Colors.white,
                  radius: 20,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _settingsRow(),
                      _divider(),
                      _settingsRow(),
                      _divider(),
                      _settingsRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsRow() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    child: Row(
      children: [
        _sBox(Colors.grey.shade300, 44, 12),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line(height: 15, widthFactor: 0.55),
              const SizedBox(height: 7),
              _line(height: 12, widthFactor: 0.8),
            ],
          ),
        ),
        _sBox(Colors.grey.shade300, 20, 10),
      ],
    ),
  );

  Widget _divider() => Container(height: 1, color: Colors.grey.shade200);
}

// ─────────────────────────────────────────────
// Legal Screen Skeleton (Terms / Privacy Policy)
// ─────────────────────────────────────────────

class LegalScreenSkeleton extends StatelessWidget {
  const LegalScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      Column(
        children: [
          Container(
            height: 200,
            color: Colors.grey.shade300,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
            child: _line(height: 26, widthFactor: 0.6),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                5,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _sectionBlock(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionBlock() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _line(height: 18, widthFactor: 0.55),
      const SizedBox(height: 12),
      _line(height: 13, widthFactor: 1),
      const SizedBox(height: 7),
      _line(height: 13, widthFactor: 0.95),
      const SizedBox(height: 7),
      _line(height: 13, widthFactor: 0.85),
      const SizedBox(height: 7),
      _line(height: 13, widthFactor: 0.65),
    ],
  );
}

// ─────────────────────────────────────────────
// Game Screen Skeleton (shared by all game pages)
// ─────────────────────────────────────────────

class GameScreenSkeleton extends StatelessWidget {
  const GameScreenSkeleton({super.key});

  Widget _optionCard() => _card(
    color: Colors.grey.shade200,
    radius: 14,
    padding: const EdgeInsets.all(18),
    child: _line(height: 15, widthFactor: 0.7),
  );
}
