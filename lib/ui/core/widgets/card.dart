import 'package:flutter/material.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    required this.child,
    this.color,
    this.textColor,
    this.accentColor,
    super.key,
    this.onTap,
    this.height,
    this.padding = 8,
  });

  final Color? color;
  final Color? textColor;
  final Color? accentColor;
  final Widget child;
  final double padding;
  final double? height;
  final void Function()? onTap;

  static const _radius = 16.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowLight = context.appColors.shadowLight;
    final borderRadius = BorderRadius.circular(_radius);

    if (color != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Ink(
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Container(
              width: double.infinity,
              height: height,
              padding: EdgeInsets.all(padding),
              alignment:
                  height != null ? Alignment.center : Alignment.topCenter,
              child: DefaultTextStyle(
                style: TextStyle(
                  color: textColor ?? colorScheme.onPrimary,
                ),
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    final accent = accentColor;
    final showFade = accent != null && padding > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: colorScheme.surfaceBright,
            borderRadius: borderRadius,
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.45),
            ),
            boxShadow: [
              BoxShadow(
                color: shadowLight,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              children: [
                if (showFade)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            accent.withValues(alpha: 0.07),
                            accent.withValues(alpha: 0.02),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.35, 1.0],
                        ),
                      ),
                    ),
                  ),
                Container(
                  width: double.infinity,
                  height: height,
                  padding: EdgeInsets.all(padding),
                  alignment: padding == 0
                      ? null
                      : (height != null
                          ? Alignment.center
                          : Alignment.topCenter),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: textColor ?? colorScheme.onSurface,
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
