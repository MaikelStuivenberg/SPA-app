part of 'photos_cubit.dart';

class PhotosState {
  PhotosState({
    this.isLoading = false,
    this.photos,
    this.currentPage = 0,
  });

  final bool isLoading;
  final List<Photo>? photos;
  final int currentPage;

  PhotosState copyWith({bool? isLoading, List<Photo>? photos, int? page}) {
    return PhotosState(
      isLoading: isLoading ?? this.isLoading,
      photos: photos ?? this.photos,
      currentPage: page ?? this.currentPage,
    );
  }
}
