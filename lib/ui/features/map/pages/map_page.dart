import 'package:flutter/material.dart';
import 'package:spa_app/core/config/remote_config_keys.dart';
import 'package:spa_app/core/di/injection.dart';
import 'package:spa_app/data/services/remote_config_service.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/features/map/widgets/map_item.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteConfig = getIt<RemoteConfigService>();
    final showMinor = remoteConfig.getBool(RemoteConfigKeys.useMinor);

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.mapTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
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
                if (showMinor) ...[
                  Text(
                    'Minor',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const MapItemWidget('W. Boothzaal', 'Ritme'),
                  const MapItemWidget('Congreshal', 'Tamboerijnen'),
                  const MapItemWidget('Serre', 'Media'),
                  const MapItemWidget('Korbelzaal', 'Brass Class - Beginner'),
                  const MapItemWidget('Schochzaal', 'Brass Class - Gevorderd'),
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
    );
  }
}
