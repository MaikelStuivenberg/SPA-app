import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/app/injection/injection.dart';
import 'package:spa_app/shared/models/photo.dart';
import 'package:spa_app/shared/repositories/photo_data.dart';

part 'photos_state.dart';

class PhotosCubit extends Cubit<PhotosState> {
  PhotosCubit() : super(PhotosState());

  Future<void> fetchLastPhotos() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      final photosRepository = getIt.get<PhotoDataRepository>();
      final photos =
          await photosRepository.getRecentImages(state.currentPage + 1);

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
    emit(state.copyWith(isLoading: true));

    try {
      final photosRepository = getIt.get<PhotoDataRepository>();
      final photos =
          await photosRepository.getRecentImages(state.currentPage + 1);

      emit(
        state.copyWith(
          isLoading: false,
          photos: [...state.photos!, ...photos],
          page: state.currentPage + 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
