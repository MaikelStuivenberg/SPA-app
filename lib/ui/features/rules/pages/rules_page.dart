import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/features/rules/widgets/rule_slide.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const _slideCount = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() => _currentPage = page);
    }
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_onPageChanged)
      ..dispose();
    super.dispose();
  }

  List<_RuleSlideData> _slides(AppLocalizations l10n, List<Color> accents) {
    return [
      _RuleSlideData(
        title: l10n.rulesRespect,
        body: l10n.rulesRespectText,
        icon: Icons.handshake,
        accentColor: accents[0],
      ),
      _RuleSlideData(
        title: l10n.rulesUnity,
        body: l10n.rulesUnityText,
        icon: Icons.groups,
        accentColor: accents[1],
      ),
      _RuleSlideData(
        title: l10n.rulesSafety,
        body: l10n.rulesSafetyText,
        icon: Icons.shield,
        accentColor: accents[2],
      ),
      _RuleSlideData(
        title: l10n.rulesTrust,
        body: l10n.rulesTrustText,
        icon: Icons.lock,
        accentColor: accents[3],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final slides = _slides(l10n, context.appColors.ruleAccents);
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              l10n.rulesTitle,
              style: theme.textTheme.headlineLarge,
            ),
          ),
          Expanded(
            child: PageView.builder(
              clipBehavior: Clip.none,
              controller: _pageController,
              itemCount: _slideCount,
              itemBuilder: (context, index) {
                final slide = slides[index];
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    var scale = 1.0;
                    if (_pageController.position.haveDimensions) {
                      final page = _pageController.page ?? index.toDouble();
                      scale = (1 - (page - index).abs() * 0.08)
                          .clamp(0.92, 1.0);
                    }
                    return RuleSlide(
                      title: slide.title,
                      body: slide.body,
                      icon: slide.icon,
                      accentColor: slide.accentColor,
                      scale: scale,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _slideCount,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: slides[_currentPage].accentColor,
                    dotColor: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  onDotClicked: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Text(
                  '${_currentPage + 1} / $_slideCount',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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

class _RuleSlideData {
  const _RuleSlideData({
    required this.title,
    required this.body,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String body;
  final IconData icon;
  final Color accentColor;
}
