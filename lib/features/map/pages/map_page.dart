import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/features/map/widgets/map_item.dart';
import 'package:spa_app/shared/widgets/default_body.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.mapTitle,
      SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              InteractiveViewer(
                maxScale: 5,
                child: Image.asset('assets/map.png'),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Text(
                    'Major',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const MapItemWidget('W. Boothzaal', 'Brass'),
                  const MapItemWidget('Bosshardt', 'Choir'),
                  const MapItemWidget('C. Boothzaal', 'Dance 13-'),
                  const MapItemWidget('Heritage', 'Dance 13+'),
                  const MapItemWidget('Witte tent', 'Sports'),
                  const MapItemWidget('Schochzaal', 'Theatre 13-'),
                  const MapItemWidget('Korbelzaal', 'Theatre 13+'),
                  const MapItemWidget('Congreshal', 'MMS'),
                  const Padding(padding: EdgeInsets.all(8)),
                  if (FirebaseRemoteConfig.instance.getBool('use_minor')) ...[
                    Text(
                      'Minor',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const MapItemWidget('W. Boothzaal', 'Ritme'),
                    const MapItemWidget('Congreshal', 'Tamboerijnen'),
                    const MapItemWidget('Serre', 'Media'),
                    const MapItemWidget('Korbelzaal', 'Brass Class - Beginner'),
                    const MapItemWidget(
                        'Schochzaal', 'Brass Class - Gevorderd',),
                    const MapItemWidget('Witte tent', 'Handige Handjes'),
                    const MapItemWidget('Heritage', 'Musical'),
                    const MapItemWidget('Bosshardt', 'Gospel'),
                    const Padding(padding: EdgeInsets.all(8)),
                  ],
                  const MapItemWidget('Vlaszaal', 'Prayer room'),
                  const Padding(padding: EdgeInsets.all(16)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
