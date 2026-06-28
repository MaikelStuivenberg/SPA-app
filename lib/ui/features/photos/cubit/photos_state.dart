part of 'photos_cubit.dart';

class PhotosState {
  const PhotosState({
    this.isLoading = false,
    this.photos,
    this.currentPage = 0,
    this.sort = AlbumPhotoSort.newestFirst,
    this.paginationCursor,
    this.hasMorePhotos = true,
  });

  final bool isLoading;
  final List<Photo>? photos;
  final int currentPage;
  final AlbumPhotoSort sort;
  final Object? paginationCursor;
  final bool hasMorePhotos;

  PhotosState copyWith({
    bool? isLoading,
    List<Photo>? photos,
    int? page,
    AlbumPhotoSort? sort,
    Object? paginationCursor,
    bool? hasMorePhotos,
    bool clearPaginationCursor = false,
  }) {
    return PhotosState(
      isLoading: isLoading ?? this.isLoading,
      photos: photos ?? this.photos,
      currentPage: page ?? currentPage,
      sort: sort ?? this.sort,
      paginationCursor: clearPaginationCursor
          ? null
          : (paginationCursor ?? this.paginationCursor),
      hasMorePhotos: hasMorePhotos ?? this.hasMorePhotos,
    );
  }
}
