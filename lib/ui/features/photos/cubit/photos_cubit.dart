import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/domain/entities/album_photo_sort.dart';
import 'package:spa_app/domain/entities/photo.dart';
import 'package:spa_app/domain/entities/photo_album_ids.dart';
import 'package:spa_app/domain/repositories/photo_repository.dart';

part 'photos_state.dart';

class PhotosCubit extends Cubit<PhotosState> {
  PhotosCubit({
    required PhotoRepository photoRepository,
    required String albumId,
  })  : _photoRepository = photoRepository,
        _albumId = albumId,
        super(const PhotosState());

  final PhotoRepository _photoRepository;
  final String _albumId;

  bool get _isFavorites => _albumId == PhotoAlbumIds.favorites;

  Future<void> fetchLastPhotos() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      if (_isFavorites) {
        await _fetchFavoritePhotos(reset: true);
        return;
      }

      final photos = await _photoRepository.getAlbumImages(
        _albumId,
        page: state.currentPage + 1,
        sort: state.sort,
      );

      emit(
        state.copyWith(
          isLoading: false,
          photos: photos,
          page: state.currentPage + 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> fetchMorePhotos() async {
    if (state.isLoading) return;
    if (_isFavorites && !state.hasMorePhotos) return;
    emit(state.copyWith(isLoading: true));

    try {
      if (_isFavorites) {
        await _fetchFavoritePhotos(reset: false);
        return;
      }

      final photos = await _photoRepository.getAlbumImages(
        _albumId,
        page: state.currentPage + 1,
        sort: state.sort,
      );

      emit(
        state.copyWith(
          isLoading: false,
          photos: [...?state.photos, ...photos],
          page: state.currentPage + 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _fetchFavoritePhotos({required bool reset}) async {
    final page = await _photoRepository.getFavoriteImagesPaginated(
      startAfter: reset
          ? null
          : state.paginationCursor as DocumentSnapshot<Object?>?,
      sort: state.sort,
    );

    emit(
      state.copyWith(
        isLoading: false,
        photos: reset ? page.photos : [...?state.photos, ...page.photos],
        paginationCursor: page.lastDocument,
        clearPaginationCursor: page.lastDocument == null,
        hasMorePhotos: page.hasMore,
        page: reset ? 1 : state.currentPage + 1,
      ),
    );
  }

  Future<void> toggleSort() async {
    if (state.isLoading || _isFavorites) return;

    final newSort = state.sort.toggled;
    emit(
      PhotosState(
        sort: newSort,
        isLoading: true,
      ),
    );

    try {
      final photos = await _photoRepository.getAlbumImages(
        _albumId,
        sort: newSort,
      );

      emit(
        PhotosState(
          sort: newSort,
          photos: photos,
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(PhotosState(sort: newSort));
    }
  }

  Future<void> toggleLike({
    required Photo photo,
    required String userId,
  }) async {
    final isLiked = photo.likedBy.contains(userId);
    if (isLiked) {
      await _photoRepository.removeLike(photo.id);
    } else {
      await _photoRepository.addLike(photo.id);
    }

    if (_isFavorites && isLiked) {
      emit(
        state.copyWith(
          photos: state.photos?.where((item) => item.id != photo.id).toList(),
        ),
      );
      return;
    }

    final updatedPhotos = state.photos?.map((item) {
      if (item.id != photo.id) return item;
      final likedBy = List<String>.from(item.likedBy);
      if (isLiked) {
        likedBy.remove(userId);
      } else {
        likedBy.add(userId);
      }
      return item.copyWith(
        likes: isLiked ? item.likes - 1 : item.likes + 1,
        likedBy: likedBy,
      );
    }).toList();

    emit(state.copyWith(photos: updatedPhotos));
  }

  Future<void> toggleLikeMultiple({
    required List<Photo> photos,
    required String userId,
  }) async {
    for (final photo in photos) {
      await toggleLike(photo: photo, userId: userId);
    }
  }
}
