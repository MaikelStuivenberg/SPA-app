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
            const Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Text("Major", style: Styles.pageSubTitle),
                  MapItemWidget('A', 'Dance 13+'),
                  MapItemWidget('E/F', 'Dance 13-'),
                  MapItemWidget('K1', 'Brass'),
                  MapItemWidget('K2', 'Theater 13+'),
                  MapItemWidget('H', 'Theater 13-'),
                  MapItemWidget('Bosshardt', 'Choir'),
                  MapItemWidget('Congreshal', 'MMS'),
                  Padding(padding: const EdgeInsets.all(16)),
                  Text("Minor", style: Styles.pageSubTitle),
                  MapItemWidget('A', 'Improvisatie'),
                  MapItemWidget('H', 'Compositie'),
                  MapItemWidget('Congreshal', 'Timbrels'),
                  MapItemWidget('Bosshardt', 'Gospel'),
                  MapItemWidget('Witte tent', 'Sport & Ministries'),
                  MapItemWidget('I', 'Media'),
                  MapItemWidget('E/F', 'Brass Class'),
                  MapItemWidget('K1', 'Ritme'),
                  Padding(padding: const EdgeInsets.all(16)),
                  Text("Overige", style: Styles.pageSubTitle),
                  MapItemWidget('B', 'Secretariaat (hotelkamer)'),
                  MapItemWidget('J', 'Prayer room'),
                  Padding(padding: const EdgeInsets.all(16)),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
