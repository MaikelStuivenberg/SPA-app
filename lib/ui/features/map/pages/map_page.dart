import 'package:flutter/material.dart';
import 'package:spa_app/core/config/remote_config_keys.dart';
import 'package:spa_app/core/di/injection.dart';
import 'package:spa_app/data/models/map_room_config.dart';
import 'package:spa_app/data/services/remote_config_service.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/core/widgets/shell_page_header.dart';
import 'package:spa_app/ui/features/map/widgets/map_item.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteConfig = getIt<RemoteConfigService>();
    final showMinor = remoteConfig.getBool(RemoteConfigKeys.useMinor);
    final rooms = MapRoomsConfig.parse(
      remoteConfig.getString(RemoteConfigKeys.mapRooms),
    );
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          ShellPageHeader(title: AppLocalizations.of(context)!.mapTitle),
          InteractiveViewer(
            maxScale: 5,
            child: Image.asset('assets/map.png'),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              border: Border(
                top: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                children: [
                  if (rooms.major.isNotEmpty) ...[
                    Text(
                      'Major',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    ...rooms.major.map(
                      (room) => MapItemWidget(room.location, room.activity),
                    ),
                    const Padding(padding: EdgeInsets.all(8)),
                  ],
                  if (showMinor && rooms.minor.isNotEmpty) ...[
                    Text(
                      'Minor',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    ...rooms.minor.map(
                      (room) => MapItemWidget(room.location, room.activity),
                    ),
                    const Padding(padding: EdgeInsets.all(8)),
                  ],
                  ...rooms.shared.map(
                    (room) => MapItemWidget(room.location, room.activity),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
