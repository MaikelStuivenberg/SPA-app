import 'package:flutter/material.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/l10n/app_localizations.dart';

class RuleSlide extends StatefulWidget {
  const RuleSlide({
    required this.title,
    required this.body,
    required this.icon,
    required this.accentColor,
    this.scale = 1,
    super.key,
  });

  final String title;
  final String body;
  final IconData icon;
  final Color accentColor;
  final double scale;

  @override
  State<RuleSlide> createState() => _RuleSlideState();
}

class _RuleSlideState extends State<RuleSlide>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late final AnimationController _arrowController;
  late final Animation<double> _arrowOffset;

  bool _canScroll = false;
  bool _showHint = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _arrowOffset = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCanScroll());
  }

  @override
  void didUpdateWidget(RuleSlide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.body != widget.body) {
      _showHint = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateCanScroll());
    }
  }

  void _updateCanScroll() {
    if (!_scrollController.hasClients) return;
    final canScroll = _scrollController.position.maxScrollExtent > 8;
    if (canScroll != _canScroll) {
      setState(() => _canScroll = canScroll);
    }
  }

  void _onScroll() {
    if (!_showHint || !_scrollController.hasClients) return;
    if (_scrollController.offset > 8) {
      setState(() => _showHint = false);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadowLight = context.appColors.shadowLight;
    final l10n = AppLocalizations.of(context)!;
    final hintColor = widget.accentColor;
    final cardBackground = Color.alphaBlend(
      widget.accentColor.withValues(alpha: 0.06),
      theme.colorScheme.surface,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Transform.scale(
            scale: widget.scale,
            child: SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: shadowLight,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ColoredBox(
                    color: cardBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: widget.accentColor
                                    .withValues(alpha: 0.15),
                                radius: 36,
                                child: Icon(
                                  widget.icon,
                                  color: widget.accentColor,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.title,
                                style:
                                    theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: widget.accentColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(
                                  20,
                                  0,
                                  20,
                                  _canScroll && _showHint ? 64 : 24,
                                ),
                                child: Text(
                                  widget.body,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (_canScroll && _showHint)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  height: 80,
                                  child: IgnorePointer(
                                    child: AnimatedOpacity(
                                      opacity: _showHint ? 1 : 0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: const [
                                              0,
                                              0.35,
                                              0.65,
                                              1,
                                            ],
                                            colors: [
                                              cardBackground.withValues(
                                                alpha: 0,
                                              ),
                                              cardBackground.withValues(
                                                alpha: 0.85,
                                              ),
                                              cardBackground,
                                              cardBackground,
                                            ],
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  l10n.rulesScrollHint,
                                                  style: theme
                                                      .textTheme.labelLarge
                                                      ?.copyWith(
                                                    color: hintColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                AnimatedBuilder(
                                                  animation: _arrowOffset,
                                                  builder: (context, child) {
                                                    return Transform.translate(
                                                      offset: Offset(
                                                        0,
                                                        _arrowOffset.value,
                                                      ),
                                                      child: child,
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 22,
                                                    color: hintColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
