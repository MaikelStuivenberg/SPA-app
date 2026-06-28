import 'dart:convert';

class FlickrAlbumConfig {
  const FlickrAlbumConfig({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;

  static List<FlickrAlbumConfig> parseList(String jsonString) {
    if (jsonString.trim().isEmpty) return [];

    try {
      final decoded = json.decode(jsonString);
      if (decoded is! List<dynamic>) return [];

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(_fromJson)
          .whereType<FlickrAlbumConfig>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  static FlickrAlbumConfig? _fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString();
    final title = json['title']?.toString();
    if (id == null || id.isEmpty || title == null || title.isEmpty) {
      return null;
    }
    return FlickrAlbumConfig(id: id, title: title);
  }
}
