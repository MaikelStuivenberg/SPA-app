import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/domain/entities/photo.dart';
import 'package:spa_app/domain/repositories/photo_repository.dart';
import 'package:spa_app/domain/repositories/user_repository.dart';
import 'package:spa_app/ui/features/user/models/user.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit({
    required UserRepository userRepository,
    required PhotoRepository photoRepository,
  })  : _userRepository = userRepository,
        _photoRepository = photoRepository,
        super(const UserProfileState());

  final UserRepository _userRepository;
  final PhotoRepository _photoRepository;

  static const likesPageSize = 9;
  DocumentSnapshot? _lastLikedDoc;

  Future<void> loadUser() async {
    emit(state.copyWith(isLoadingUser: true, clearUserError: true));
    try {
      final user = await _userRepository.getUser();
      emit(state.copyWith(isLoadingUser: false, user: user));
    } catch (error) {
      emit(
        state.copyWith(
          isLoadingUser: false,
          userError: error.toString(),
        ),
      );
    }
  }

  Future<void> setProfileImage(Uint8List imageBytes) async {
    await _userRepository.setProfileImage(imageBytes);
    await loadUser();
  }

  Future<void> loadLikedPhotos() async {
    if (state.isLoadingLikes || !state.hasMoreLikes) return;

    emit(state.copyWith(isLoadingLikes: true, clearLikesError: true));
    try {
      final page = await _photoRepository.getMyLikedPhotosPaginated(
        limit: likesPageSize,
        startAfter: _lastLikedDoc,
      );

      if (page.lastDocument != null) {
        _lastLikedDoc = page.lastDocument;
      }

      emit(
        state.copyWith(
          isLoadingLikes: false,
          likedPhotos: [...state.likedPhotos, ...page.photos],
          hasMoreLikes: page.photos.length >= likesPageSize,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoadingLikes: false,
          likesError: error.toString(),
        ),
      );
    }
  }

  Future<void> removeLikedPhotos(List<Photo> photos) async {
    for (final photo in photos) {
      await _photoRepository.removeLike(photo.id);
    }

    final removedIds = photos.map((photo) => photo.id).toSet();
    emit(
      state.copyWith(
        likedPhotos: state.likedPhotos
            .where((photo) => !removedIds.contains(photo.id))
            .toList(),
      ),
    );
  }
}
