import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/domain/entities/photo_album.dart';
import 'package:spa_app/domain/entities/photo_album_ids.dart';
import 'package:spa_app/domain/repositories/photo_repository.dart';

part 'albums_state.dart';

class AlbumsCubit extends Cubit<AlbumsState> {
  AlbumsCubit({required PhotoRepository photoRepository})
      : _photoRepository = photoRepository,
        super(const AlbumsState());

  final PhotoRepository _photoRepository;

  Future<void> fetchAlbums() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      final results = await Future.wait([
        _photoRepository.getAlbums(),
        _photoRepository.getFavoritesAlbum(),
      ]);
      final albums = results[0] as List<PhotoAlbum>;
      final favoritesAlbum = results[1] as PhotoAlbum?;

      emit(
        state.copyWith(
          isLoading: false,
          albums: albums,
          favoritesAlbum: favoritesAlbum,
          clearFavoritesAlbum: favoritesAlbum == null,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  PhotoAlbum? albumById(String albumId) {
    if (albumId == PhotoAlbumIds.favorites) {
      return state.favoritesAlbum;
    }

    final albums = state.albums;
    if (albums == null) return null;
    for (final album in albums) {
      if (album.id == albumId) return album;
    }
    return null;
  }
}
