import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';

/// Poster-style brand glow behind auth screens (login, register).
enum AuthBackgroundIntensity { standard, subtle }

class AuthDecorativeBackground extends StatefulWidget {
  const AuthDecorativeBackground({
    this.intensity = AuthBackgroundIntensity.standard,
    super.key,
  });

  final AuthBackgroundIntensity intensity;

  @override
  State<AuthDecorativeBackground> createState() =>
      _AuthDecorativeBackgroundState();
}

class _AuthDecorativeBackgroundState extends State<AuthDecorativeBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _driftController;
  late final Animation<double> _driftAnimation;

  bool get _isSubtle => widget.intensity == AuthBackgroundIntensity.subtle;

  @override
  void initState() {
    super.initState();
    _driftController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _isSubtle ? 10 : 8),
    );
    _driftAnimation = CurvedAnimation(
      parent: _driftController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _startDriftIfAllowed());
  }

  void _startDriftIfAllowed() {
    if (!mounted) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _driftController.stop();
      return;
    }
    if (!_driftController.isAnimating) {
      _driftController.repeat(reverse: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startDriftIfAllowed();
  }

  @override
  void dispose() {
    _driftController.dispose();
    super.dispose();
  }

  double _lerp(double from, double to, double t) => from + (to - from) * t;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final cyan = appColors.accent;
    final navy = colorScheme.primary;
    final salvationRed = appColors.favorite;

    final cyanPeak = _isSubtle ? 0.14 : (isDark ? 0.19 : 0.17);
    final cyanSize = _isSubtle ? 220.0 : 300.0;

    final navyPeak = _isSubtle ? 0.09 : (isDark ? 0.12 : 0.13);
    final navySize = _isSubtle ? 180.0 : 260.0;

    final redPeak = _isSubtle ? 0.11 : (isDark ? 0.16 : 0.17);
    final redSize = _isSubtle ? 200.0 : 270.0;
    final redAccentPeak = _isSubtle ? 0.08 : 0.11;
    final redAccentSize = _isSubtle ? 140.0 : 175.0;

    final showNavy = !_isSubtle || !isDark;

    final drift = reduceMotion ? 0.0 : _driftAnimation.value;
    final cyanBreathe =
        reduceMotion ? 1.0 : (0.96 + 0.04 * math.sin(drift * math.pi));
    final navyBreathe = reduceMotion
        ? 1.0
        : (0.96 + 0.04 * math.sin((drift + 0.35) * math.pi));
    final redBreathe = reduceMotion
        ? 1.0
        : (0.96 + 0.04 * math.sin((drift + 0.65) * math.pi));

    final cyanTravel = _isSubtle ? 12.0 : 18.0;
    final navyTravel = _isSubtle ? 10.0 : 16.0;
    final redTravel = _isSubtle ? 8.0 : 14.0;
    final cyanScale = _isSubtle ? 0.04 : 0.05;

    Widget buildGlowStack(double t) {
      final cyanDx = _lerp(0, cyanTravel, t);
      final cyanDy = _lerp(0, cyanTravel * 0.75, t);
      final navyDx = _lerp(0, -navyTravel * 0.8, t);
      final navyDy = _lerp(0, navyTravel, t);
      final redDx = _lerp(0, redTravel * 0.6, t);
      final redDy = _lerp(0, -redTravel * 0.5, t);
      final scale = 1 + (cyanScale * math.sin(t * math.pi));

      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -60 + cyanDy,
            right: -80 - cyanDx,
            child: Transform.scale(
              scale: scale,
              child: _GlowBlob(
                size: cyanSize,
                color: cyan,
                peakOpacity: cyanPeak * cyanBreathe,
              ),
            ),
          ),
          if (showNavy)
            Positioned(
              bottom: 60 - navyDy,
              left: -70 + navyDx,
              child: Transform.scale(
                scale: 1 + (cyanScale * 0.85 * math.sin((t + 0.35) * math.pi)),
                child: _GlowBlob(
                  size: navySize,
                  color: isDark ? cyan : navy,
                  peakOpacity: navyPeak * navyBreathe,
                ),
              ),
            ),
          Positioned(
            top: 36 + redDy,
            left: -20 + redDx,
            child: Transform.scale(
              scale: 1 + (cyanScale * 0.7 * math.sin((t + 0.65) * math.pi)),
              child: _GlowBlob(
                size: redSize,
                color: salvationRed,
                peakOpacity: redPeak * redBreathe,
                warmGlow: true,
              ),
            ),
          ),
          if (!_isSubtle)
            Positioned(
              bottom: 200 - redDy * 0.6,
              right: -50 - redDx * 0.5,
              child: Transform.scale(
                scale:
                    1 + (cyanScale * 0.6 * math.sin((t + 0.85) * math.pi)),
                child: _GlowBlob(
                  size: redAccentSize,
                  color: salvationRed,
                  peakOpacity: redAccentPeak * redBreathe,
                  warmGlow: true,
                ),
              ),
            ),
          if (!_isSubtle) ...[
            Positioned(
              top: 52,
              right: 28,
              child: FaIcon(
                FontAwesomeIcons.masksTheater,
                size: 34,
                color: navy.withValues(alpha: 0.14),
              ),
            ),
            Positioned(
              bottom: 108,
              left: 32,
              child: FaIcon(
                FontAwesomeIcons.music,
                size: 30,
                color: salvationRed.withValues(alpha: 0.14),
              ),
            ),
          ],
        ],
      );
    }

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _driftAnimation,
        builder: (context, child) => buildGlowStack(
          reduceMotion ? 0 : _driftAnimation.value,
        ),
      ),
    );
  }
}

/// Soft radial wash — visible poster glow without blur diluting the color.
class _GlowBlob extends StatelessWidget {
  const _GlowBlob({
    required this.size,
    required this.color,
    required this.peakOpacity,
    this.warmGlow = false,
  });

  final double size;
  final Color color;
  final double peakOpacity;
  final bool warmGlow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: peakOpacity),
            color.withValues(alpha: peakOpacity * (warmGlow ? 0.48 : 0.45)),
            color.withValues(alpha: 0),
          ],
          stops: warmGlow ? const [0.0, 0.38, 1.0] : const [0.0, 0.42, 1.0],
        ),
      ),
    );
  }
}
