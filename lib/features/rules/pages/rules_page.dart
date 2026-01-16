import 'package:flutter/material.dart';
import 'package:spa_app/features/rules/widgets/rule_container.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/shared/widgets/default_body.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  RulesPageState createState() => RulesPageState();
}

class RulesPageState extends State<RulesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.rulesTitle,
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              RuleContainerWidget(
                AppLocalizations.of(context)!.rulesRespect.toUpperCase(),
                AppLocalizations.of(context)!.rulesRespectText,
                icon: Icons.handshake,
              ),
              RuleContainerWidget(
                AppLocalizations.of(context)!.rulesUnity.toUpperCase(),
                AppLocalizations.of(context)!.rulesUnityText,
                icon: Icons.groups,
              ),
              RuleContainerWidget(
                AppLocalizations.of(context)!.rulesSafety.toUpperCase(),
                AppLocalizations.of(context)!.rulesSafetyText,
                icon: Icons.shield,
              ),
              RuleContainerWidget(
                AppLocalizations.of(context)!.rulesTrust.toUpperCase(),
                AppLocalizations.of(context)!.rulesTrustText,
                icon: Icons.lock,
              ),
              Container(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
