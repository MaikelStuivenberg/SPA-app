import 'package:flutter_test/flutter_test.dart';
import 'package:spa_app/data/models/map_room_config.dart';

void main() {
  group('MapRoomsConfig', () {
    test('parses major, minor, and shared room lists', () {
      const json = '''
{
  "major": [
    {"location": "W. Boothzaal", "activity": "Brass"},
    {"location": "Bosshardt", "activity": "Choir"}
  ],
  "minor": [
    {"location": "Serre", "activity": "Media"}
  ],
  "shared": [
    {"location": "Vlaszaal", "activity": "Prayer room"}
  ]
}
''';

      final rooms = MapRoomsConfig.parse(json);

      expect(rooms.major, hasLength(2));
      expect(rooms.major.first.location, 'W. Boothzaal');
      expect(rooms.major.first.activity, 'Brass');
      expect(rooms.minor, hasLength(1));
      expect(rooms.shared, hasLength(1));
    });

    test('skips invalid entries', () {
      const json = '''
{
  "major": [
    {"location": "W. Boothzaal", "activity": "Brass"},
    {"location": "", "activity": "Invalid"},
    {"activity": "Missing location"}
  ],
  "minor": [],
  "shared": []
}
''';

      final rooms = MapRoomsConfig.parse(json);

      expect(rooms.major, hasLength(1));
    });

    test('returns empty config for invalid json', () {
      expect(MapRoomsConfig.parse('not-json'), MapRoomsConfig.empty);
      expect(MapRoomsConfig.parse('[]'), MapRoomsConfig.empty);
      expect(MapRoomsConfig.parse(''), MapRoomsConfig.empty);
    });
  });
}
