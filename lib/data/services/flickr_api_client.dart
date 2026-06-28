import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spa_app/core/config/environment.dart';
import 'package:spa_app/core/config/remote_config_keys.dart';
import 'package:spa_app/data/services/remote_config_service.dart';
import 'package:spa_app/domain/entities/album_photo_sort.dart';

class FlickrPhotoData {
  const FlickrPhotoData({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
  });

  final String id;
  final String url;
  final String thumbnailUrl;
}

class FlickrAlbumInfoData {
  const FlickrAlbumInfoData({
    required this.coverThumbnailUrl,
    required this.photoCount,
  });

  final String coverThumbnailUrl;
  final int photoCount;
}

class FlickrApiClient {
  FlickrApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<FlickrPhotoData>> fetchRecentPhotos({
    required int page,
    required RemoteConfigService remoteConfigService,
  }) async {
    final minUploadDate =
        remoteConfigService.getInt(RemoteConfigKeys.flickrMinUploadDate);
    final maxUploadDate =
        remoteConfigService.getInt(RemoteConfigKeys.flickrMaxUploadDate);
    final photosPerPage =
        remoteConfigService.getInt(RemoteConfigKeys.showPhotosPerPage);

    final url = Uri.parse(
      'https://www.flickr.com/services/rest/'
      '?method=flickr.people.getPhotos'
      '&api_key=${Environment.flickrApiKey}'
      '&user_id=${Environment.flickrUserId}'
      '&extras=url_m,date_taken,url_k'
      '&sort=date-taken-desc'
      '&min_upload_date=$minUploadDate'
      '&max_upload_date=$maxUploadDate'
      '&per_page=$photosPerPage'
      '&page=$page'
      '&format=json'
      '&nojsoncallback=1',
    );

    final response = await _client.get(url);
    if (response.statusCode != 200) return [];

    final data = json.decode(response.body) as Map<String, dynamic>;
    final photos = data['photos']['photo'] as List<dynamic>;

    return photos
        .map(
          (photo) => FlickrPhotoData(
            id: photo['id'] as String,
            url: photo['url_k'] as String,
            thumbnailUrl: photo['url_m'] as String,
          ),
        )
        .toList();
  }

  Future<FlickrAlbumInfoData?> fetchAlbumInfo(String photosetId) async {
    final url = Uri.parse(
      'https://www.flickr.com/services/rest/'
      '?method=flickr.photosets.getInfo'
      '&api_key=${Environment.flickrApiKey}'
      '&photoset_id=$photosetId'
      '&primary_photo_extras=url_m'
      '&format=json'
      '&nojsoncallback=1',
    );

    final response = await _client.get(url);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data['stat'] != 'ok') return null;

    final photoset = data['photoset'] as Map<String, dynamic>;
    final coverUrl = photoset['primary_photo_extras']?['url_m'] as String?;
    if (coverUrl == null || coverUrl.isEmpty) return null;

    return FlickrAlbumInfoData(
      coverThumbnailUrl: coverUrl,
      photoCount: int.tryParse(photoset['photos']?.toString() ?? '') ?? 0,
    );
  }

  Future<List<FlickrPhotoData>> fetchAlbumPhotos({
    required String photosetId,
    required int page,
    required AlbumPhotoSort sort,
    required RemoteConfigService remoteConfigService,
  }) async {
    final photosPerPage =
        remoteConfigService.getInt(RemoteConfigKeys.showPhotosPerPage);

    final url = Uri.parse(
      'https://www.flickr.com/services/rest/'
      '?method=flickr.photosets.getPhotos'
      '&api_key=${Environment.flickrApiKey}'
      '&photoset_id=$photosetId'
      '&extras=url_m,url_k'
      '&sort=${sort.flickrValue}'
      '&per_page=$photosPerPage'
      '&page=$page'
      '&format=json'
      '&nojsoncallback=1',
    );

    final response = await _client.get(url);
    if (response.statusCode != 200) return [];

    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data['stat'] != 'ok') return [];

    final photos = data['photoset']['photo'] as List<dynamic>? ?? [];

    return photos
        .map(
          (photo) => FlickrPhotoData(
            id: photo['id'] as String,
            url: photo['url_k'] as String,
            thumbnailUrl: photo['url_m'] as String,
          ),
        )
        .toList();
  }

  Future<FlickrPhotoData?> fetchPhotoSizes(String photoId) async {
    final url = Uri.parse(
      'https://www.flickr.com/services/rest/'
      '?method=flickr.photos.getSizes'
      '&api_key=${Environment.flickrApiKey}'
      '&photo_id=$photoId'
      '&format=json'
      '&nojsoncallback=1'
      '&extras=url_m,url_k',
    );

    final response = await _client.get(url);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body) as Map<String, dynamic>;
    final sizes = data['sizes']['size'] as List<dynamic>;

    final large = sizes.firstWhere(
      (element) => element['label'].toString() == 'Large 2048',
    );
    final medium = sizes.firstWhere(
      (element) => element['label'].toString() == 'Medium',
    );

    return FlickrPhotoData(
      id: photoId,
      url: large['source'] as String,
      thumbnailUrl: medium['source'] as String,
    );
  }
}
