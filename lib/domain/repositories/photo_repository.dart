import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spa_app/domain/entities/album_photo_sort.dart';
import 'package:spa_app/domain/entities/photo.dart';
import 'package:spa_app/domain/entities/photo_album.dart';

class PhotoPage {
  const PhotoPage({
    required this.photos,
    this.lastDocument,
    this.hasMore = true,
  });

  final List<Photo> photos;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;
}

abstract class PhotoRepository {
  Future<List<Photo>> getRecentImages([int page = 1]);
  Future<List<PhotoAlbum>> getAlbums();
  Future<PhotoAlbum?> getFavoritesAlbum();
  Future<List<Photo>> getAlbumImages(
    String albumId, {
    int page = 1,
    AlbumPhotoSort sort = AlbumPhotoSort.newestFirst,
  });
  Future<void> addLike(String photoId);
  Future<void> removeLike(String photoId);
  Future<int> getLikes(String photoId);
  Future<List<String>> getLikedBy(String photoId);
  Future<List<Photo>> getMyLikedPhotos();
  Future<PhotoPage> getMyLikedPhotosPaginated({
    required int limit,
    DocumentSnapshot? startAfter,
    bool descending = true,
  });
  Future<PhotoPage> getFavoriteImagesPaginated({
    DocumentSnapshot? startAfter,
    AlbumPhotoSort sort = AlbumPhotoSort.newestFirst,
  });
}
