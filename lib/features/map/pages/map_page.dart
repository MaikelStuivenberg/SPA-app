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
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return DefaultBodyWidget(
      SafeArea(
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.mapTitle,
              style: Styles.pageTitle,
            ),
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
                  MapItemWidget('A', 'Brass'),
                  MapItemWidget('B', 'Administratie'),
                  MapItemWidget('Bosshardt', 'Choir'),
                  MapItemWidget('Congreshal', 'MMS / Opening / Worship'),
                  MapItemWidget('E/F', 'Dance 13-'),
                  MapItemWidget('K1', 'Dance 13+'),
                  MapItemWidget('K2', 'Theater'),
                  MapItemWidget('Restaurant', 'Ontbijt / Lunch / Diner'),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
