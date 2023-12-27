import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_app/features/map/widgets/map_item.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/styles.dart';

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
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5,
                  child: Image.asset('assets/map.png'),
                ),
              ),
              Column(
                children: [
                  const Text('Major', style: Styles.pageSubTitle),
                  const MapItemWidget('A', 'Dance 13+'),
                  const MapItemWidget('E/F', 'Dance 13-'),
                  const MapItemWidget('K1', 'Brass'),
                  const MapItemWidget('K2', 'Theater 13+'),
                  const MapItemWidget('H', 'Theater 13-'),
                  const MapItemWidget('Bosshardt', 'Choir'),
                  const MapItemWidget('Congreshal', 'MMS'),
                  const Padding(padding: EdgeInsets.all(8)),
                  if (FirebaseRemoteConfig.instance.getBool('use_minor')) ...[
                    const Text('Minor', style: Styles.pageSubTitle),
                    const MapItemWidget('A', 'Improvisatie'),
                    const MapItemWidget('H', 'Compositie'),
                    const MapItemWidget('Congreshal', 'Timbrels'),
                    const MapItemWidget('Bosshardt', 'Gospel'),
                    const MapItemWidget('Witte tent', 'Sport & Ministries'),
                    const MapItemWidget('I', 'Media'),
                    const MapItemWidget('E/F', 'Brass Class'),
                    const MapItemWidget('K1', 'Ritme'),
                    const Padding(padding: EdgeInsets.all(8)),
                  ],
                  const Text('Overige', style: Styles.pageSubTitle),
                  const MapItemWidget('B', 'Secretariaat (hotelkamer)'),
                  const MapItemWidget('J', 'Prayer room'),
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
