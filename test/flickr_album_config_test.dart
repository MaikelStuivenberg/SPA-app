import 'package:flutter_test/flutter_test.dart';
import 'package:spa_app/data/models/flickr_album_config.dart';

void main() {
  group('FlickrAlbumConfig', () {
    test('parseList returns albums for valid JSON', () {
      const json = '''
[
  {"id":"72177720331523846","title":"SPA NYP 2026"},
  {"id":"72177720327684878","title":"SPA 2025"}
]
''';

      final albums = FlickrAlbumConfig.parseList(json);

      expect(albums, hasLength(2));
      expect(albums.first.id, '72177720331523846');
      expect(albums.first.title, 'SPA NYP 2026');
      expect(albums.last.id, '72177720327684878');
    });

    test('parseList skips invalid entries', () {
      const json = '''
[
  {"id":"","title":"Missing id"},
  {"title":"Missing id key"},
  {"id":"123","title":"Valid"}
]
''';

      final albums = FlickrAlbumConfig.parseList(json);

      expect(albums, hasLength(1));
      expect(albums.single.title, 'Valid');
    });

    test('parseList returns empty list for malformed JSON', () {
      expect(FlickrAlbumConfig.parseList('not-json'), isEmpty);
      expect(FlickrAlbumConfig.parseList('{}'), isEmpty);
      expect(FlickrAlbumConfig.parseList(''), isEmpty);
    });
  });
}
