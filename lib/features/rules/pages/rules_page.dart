import 'package:flutter/material.dart';
import 'package:spa_app/features/rules/widgets/rule_container.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return DefaultBodyWidget(
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.rulesTitle,
                style: Styles.pageTitle,
              ),
              RuleContainerWidget(
                AppLocalizations.of(context)!.rulesRespect.toUpperCase(),
                AppLocalizations.of(context)!.rulesRespectText,
              ),
              RuleContainerWidget(
                AppLocalizations.of(context)!.rulesUnity.toUpperCase(),
                AppLocalizations.of(context)!.rulesUnityText,
              ),
              RuleContainerWidget(
                AppLocalizations.of(context)!.rulesSafety.toUpperCase(),
                AppLocalizations.of(context)!.rulesSafetyText,
              ),
              RuleContainerWidget(
                AppLocalizations.of(context)!.rulesTrust.toUpperCase(),
                AppLocalizations.of(context)!.rulesTrustText,
              ),
              Container(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
