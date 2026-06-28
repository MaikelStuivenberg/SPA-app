part of 'albums_cubit.dart';

class AlbumsState {
  const AlbumsState({
    this.isLoading = false,
    this.albums,
    this.favoritesAlbum,
  });

  final bool isLoading;
  final List<PhotoAlbum>? albums;
  final PhotoAlbum? favoritesAlbum;

  AlbumsState copyWith({
    bool? isLoading,
    List<PhotoAlbum>? albums,
    PhotoAlbum? favoritesAlbum,
    bool clearFavoritesAlbum = false,
  }) {
    return AlbumsState(
      isLoading: isLoading ?? this.isLoading,
      albums: albums ?? this.albums,
      favoritesAlbum:
          clearFavoritesAlbum ? null : (favoritesAlbum ?? this.favoritesAlbum),
    );
  }
}
