import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/l10n/app_localizations.dart';

class OnboardingWelcomeStep extends StatefulWidget {
  const OnboardingWelcomeStep({
    required this.firstname,
    required this.onFinish,
    this.hasPhoto = false,
    super.key,
  });

  final String firstname;
  final Future<void> Function() onFinish;
  final bool hasPhoto;

  @override
  State<OnboardingWelcomeStep> createState() => _OnboardingWelcomeStepState();
}

class _OnboardingWelcomeStepState extends State<OnboardingWelcomeStep> {
  late final ConfettiController _confettiController;
  var _isFinishing = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accents = context.appColors.decorativeAccents;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: accents,
            numberOfParticles: 24,
            maxBlastForce: 24,
            minBlastForce: 12,
            gravity: 0.12,
            createParticlePath: (size) {
              final path = Path();
              path.addOval(
                Rect.fromCircle(
                  center: Offset.zero,
                  radius: size.width / 2,
                ),
              );
              return path;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                child: FaIcon(
                  FontAwesomeIcons.masksTheater,
                  size: 36,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.onboardingWelcomeTitle(widget.firstname),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.onboardingWelcomeBody,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFinishing
                      ? null
                      : () async {
                          setState(() => _isFinishing = true);
                          await widget.onFinish();
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isFinishing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.onboardingLetsGo),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
