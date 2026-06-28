import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spa_app/core/config/remote_config_keys.dart';
import 'package:spa_app/data/models/flickr_album_config.dart';
import 'package:spa_app/data/services/flickr_api_client.dart';
import 'package:spa_app/data/services/remote_config_service.dart';
import 'package:spa_app/domain/entities/album_photo_sort.dart';
import 'package:spa_app/domain/entities/photo.dart';
import 'package:spa_app/domain/entities/photo_album.dart';
import 'package:spa_app/domain/entities/photo_album_ids.dart';
import 'package:spa_app/domain/repositories/photo_repository.dart';
import 'package:spa_app/domain/repositories/user_repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl({
    required UserRepository userRepository,
    required RemoteConfigService remoteConfigService,
    required FlickrApiClient flickrApiClient,
    FirebaseFirestore? firestore,
  })  : _userRepository = userRepository,
        _remoteConfigService = remoteConfigService,
        _flickrApiClient = flickrApiClient,
        _photosCollection =
            (firestore ?? FirebaseFirestore.instance).collection('photos');

  final UserRepository _userRepository;
  final RemoteConfigService _remoteConfigService;
  final FlickrApiClient _flickrApiClient;
  final CollectionReference<Map<String, dynamic>> _photosCollection;

  @override
  Future<List<Photo>> getRecentImages([int page = 1]) async {
    final flickrPhotos = await _flickrApiClient.fetchRecentPhotos(
      page: page,
      remoteConfigService: _remoteConfigService,
    );

    return _enrichPhotosWithLikes(flickrPhotos);
  }

  @override
  Future<List<PhotoAlbum>> getAlbums() async {
    final configJson =
        _remoteConfigService.getString(RemoteConfigKeys.flickrAlbums);
    final albumConfigs = FlickrAlbumConfig.parseList(configJson);

    final albums = await Future.wait(
      albumConfigs.map((config) async {
        final info = await _flickrApiClient.fetchAlbumInfo(config.id);
        if (info == null) return null;

        return PhotoAlbum(
          id: config.id,
          title: config.title,
          coverThumbnailUrl: info.coverThumbnailUrl,
          photoCount: info.photoCount,
        );
      }),
    );

    return albums.whereType<PhotoAlbum>().toList();
  }

  @override
  Future<List<Photo>> getAlbumImages(
    String albumId, {
    int page = 1,
    AlbumPhotoSort sort = AlbumPhotoSort.newestFirst,
  }) async {
    final flickrPhotos = await _flickrApiClient.fetchAlbumPhotos(
      photosetId: albumId,
      page: page,
      sort: sort,
      remoteConfigService: _remoteConfigService,
    );

    return _enrichPhotosWithLikes(flickrPhotos);
  }

  @override
  Future<PhotoAlbum?> getFavoritesAlbum() async {
    final userId = await _userRepository.getCurrentUserId();
    final query =
        _photosCollection.where('likedBy', arrayContains: userId);

    final countSnapshot = await query.count().get();
    final count = countSnapshot.count ?? 0;
    if (count == 0) return null;

    final latestSnapshot = await query
        .orderBy(FieldPath.documentId, descending: true)
        .limit(1)
        .get();
    if (latestSnapshot.docs.isEmpty) return null;

    final latestDoc = latestSnapshot.docs.first;
    final coverPhoto = await _buildPhotoFromFlickr(
      latestDoc.id,
      likedBy: _parseLikedBy(latestDoc.data()),
    );
    if (coverPhoto == null) return null;

    return PhotoAlbum(
      id: PhotoAlbumIds.favorites,
      title: 'Favorites',
      coverThumbnailUrl: coverPhoto.thumbnailUrl,
      photoCount: count,
      isFavorites: true,
    );
  }

  @override
  Future<PhotoPage> getFavoriteImagesPaginated({
    DocumentSnapshot? startAfter,
    AlbumPhotoSort sort = AlbumPhotoSort.newestFirst,
  }) async {
    final limit =
        _remoteConfigService.getInt(RemoteConfigKeys.showPhotosPerPage);
    return getMyLikedPhotosPaginated(
      limit: limit,
      startAfter: startAfter,
      descending: sort == AlbumPhotoSort.newestFirst,
    );
  }

  Future<List<Photo>> _enrichPhotosWithLikes(
    List<FlickrPhotoData> flickrPhotos,
  ) async {
    final photoResult = <Photo>[];
    for (final flickrPhoto in flickrPhotos) {
      photoResult.add(
        Photo(
          id: flickrPhoto.id,
          url: flickrPhoto.url,
          thumbnailUrl: flickrPhoto.thumbnailUrl,
          likes: await getLikes(flickrPhoto.id),
          likedBy: await getLikedBy(flickrPhoto.id),
        ),
      );
    }
    return photoResult;
  }

  @override
  Future<void> addLike(String photoId) async {
    final userId = await _userRepository.getCurrentUserId();
    final doc = await _photosCollection.doc(photoId).get();
    if (!doc.exists) {
      await _photosCollection.doc(photoId).set({
        'likedBy': [userId],
      });
      return;
    }

    await _photosCollection.doc(photoId).update({
      'likedBy': FieldValue.arrayUnion([userId]),
    });
  }

  @override
  Future<void> removeLike(String photoId) async {
    final userId = await _userRepository.getCurrentUserId();
    await _photosCollection.doc(photoId).update({
      'likedBy': FieldValue.arrayRemove([userId]),
    });
  }

  @override
  Future<int> getLikes(String photoId) async {
    final snapshot = await _photosCollection.doc(photoId).get();
    final data = snapshot.data();

    if (data == null || data['likedBy'] == null) {
      return 0;
    }

    return (data['likedBy'] as List<dynamic>).length;
  }

  @override
  Future<List<String>> getLikedBy(String photoId) async {
    final snapshot = await _photosCollection.doc(photoId).get();
    final data = snapshot.data();

    if (data == null) {
      return [];
    }

    return (data['likedBy'] as List<dynamic>).map((e) => e.toString()).toList();
  }

  @override
  Future<List<Photo>> getMyLikedPhotos() async {
    final userId = await _userRepository.getCurrentUserId();
    final querySnapshot =
        await _photosCollection.where('likedBy', arrayContains: userId).get();
    final myPhotos = querySnapshot.docs.map((doc) => doc.id).toList().reversed;

    final likedPhotos = <Photo>[];
    for (final photoId in myPhotos) {
      final photo = await _buildPhotoFromFlickr(photoId);
      if (photo != null) {
        likedPhotos.add(photo);
      }
    }
    return likedPhotos;
  }

  @override
  Future<PhotoPage> getMyLikedPhotosPaginated({
    required int limit,
    DocumentSnapshot? startAfter,
    bool descending = true,
  }) async {
    final userId = await _userRepository.getCurrentUserId();

    var query = _photosCollection
        .where('likedBy', arrayContains: userId)
        .orderBy(FieldPath.documentId, descending: descending)
        .limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final querySnapshot = await query.get();

    final photos = await Future.wait(
      querySnapshot.docs.map((doc) {
        final likedBy = _parseLikedBy(doc.data());
        return _buildPhotoFromFlickr(doc.id, likedBy: likedBy);
      }),
    );

    return PhotoPage(
      photos: photos.whereType<Photo>().toList(),
      lastDocument:
          querySnapshot.docs.isEmpty ? null : querySnapshot.docs.last,
      hasMore: photos.whereType<Photo>().length >= limit,
    );
  }

  List<String> _parseLikedBy(Map<String, dynamic> data) {
    final raw = data['likedBy'];
    if (raw is! List<dynamic>) return [];
    return raw.map((entry) => entry.toString()).toList();
  }

  Future<Photo?> _buildPhotoFromFlickr(
    String photoId, {
    List<String>? likedBy,
  }) async {
    final flickrPhoto = await _flickrApiClient.fetchPhotoSizes(photoId);
    if (flickrPhoto == null) return null;

    final resolvedLikedBy = likedBy ?? await getLikedBy(photoId);

    return Photo(
      id: photoId,
      url: flickrPhoto.url,
      thumbnailUrl: flickrPhoto.thumbnailUrl,
      likes: resolvedLikedBy.length,
      likedBy: resolvedLikedBy,
    );
  }
}
