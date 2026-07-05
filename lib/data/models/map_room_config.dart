import 'dart:convert';

class MapRoomEntry {
  const MapRoomEntry({
    required this.location,
    required this.activity,
  });

  final String location;
  final String activity;

  static MapRoomEntry? fromJson(Map<String, dynamic> json) {
    final location = json['location']?.toString();
    final activity = json['activity']?.toString();
    if (location == null ||
        location.isEmpty ||
        activity == null ||
        activity.isEmpty) {
      return null;
    }
    return MapRoomEntry(location: location, activity: activity);
  }
}

class MapRoomsConfig {
  const MapRoomsConfig({
    required this.major,
    required this.minor,
    required this.shared,
  });

  static const empty = MapRoomsConfig(
    major: [],
    minor: [],
    shared: [],
  );

  final List<MapRoomEntry> major;
  final List<MapRoomEntry> minor;
  final List<MapRoomEntry> shared;

  static MapRoomsConfig parse(String jsonString) {
    if (jsonString.trim().isEmpty) return MapRoomsConfig.empty;

    try {
      final decoded = json.decode(jsonString);
      if (decoded is! Map<String, dynamic>) return MapRoomsConfig.empty;

      return MapRoomsConfig(
        major: _parseRoomList(decoded['major']),
        minor: _parseRoomList(decoded['minor']),
        shared: _parseRoomList(decoded['shared']),
      );
    } catch (_) {
      return MapRoomsConfig.empty;
    }
  }

  static List<MapRoomEntry> _parseRoomList(Object? value) {
    if (value is! List<dynamic>) return [];

    return value
        .whereType<Map<String, dynamic>>()
        .map(MapRoomEntry.fromJson)
        .whereType<MapRoomEntry>()
        .toList();
  }
}
