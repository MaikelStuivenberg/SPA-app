import 'package:spa_app/core/config/remote_config_keys.dart';
import 'package:spa_app/data/services/remote_config_service.dart';

/// Camp window from Remote Config (`start_date` / `end_date`).
///
/// Matches program schedule filtering: exclusive on both bounds.
class CampDateRange {
  const CampDateRange({required this.start, required this.end});

  factory CampDateRange.fromRemoteConfig(RemoteConfigService remoteConfig) {
    return CampDateRange(
      start: DateTime.parse(remoteConfig.getString(RemoteConfigKeys.startDate)),
      end: DateTime.parse(remoteConfig.getString(RemoteConfigKeys.endDate)),
    );
  }

  final DateTime start;
  final DateTime end;

  bool contains(DateTime date) => date.isAfter(start) && date.isBefore(end);
}
