import 'package:flutter/material.dart';

/// Non-interactive horizontal bars showing onboarding progress (not page dots).
class OnboardingStepIndicator extends StatelessWidget {
  const OnboardingStepIndicator({
    required this.currentStep,
    required this.stepCount,
    super.key,
  });

  final int currentStep;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: List.generate(stepCount, (index) {
        final isActive = index <= currentStep;
        final isCurrent = index == currentStep;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < stepCount - 1 ? 8 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isCurrent ? 4 : 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.25),
              ),
            ),
          ),
        );
      }),
    );
  }
}
