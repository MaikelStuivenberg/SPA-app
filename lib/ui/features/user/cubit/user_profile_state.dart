part of 'user_profile_cubit.dart';

class UserProfileState {
  const UserProfileState({
    this.isLoadingUser = false,
    this.user,
    this.userError,
    this.likedPhotos = const [],
    this.isLoadingLikes = false,
    this.hasMoreLikes = true,
    this.likesError,
  });

  final bool isLoadingUser;
  final UserData? user;
  final String? userError;
  final List<Photo> likedPhotos;
  final bool isLoadingLikes;
  final bool hasMoreLikes;
  final String? likesError;

  UserProfileState copyWith({
    bool? isLoadingUser,
    UserData? user,
    String? userError,
    bool clearUserError = false,
    List<Photo>? likedPhotos,
    bool? isLoadingLikes,
    bool? hasMoreLikes,
    String? likesError,
    bool clearLikesError = false,
  }) {
    return UserProfileState(
      isLoadingUser: isLoadingUser ?? this.isLoadingUser,
      user: user ?? this.user,
      userError: clearUserError ? null : userError ?? this.userError,
      likedPhotos: likedPhotos ?? this.likedPhotos,
      isLoadingLikes: isLoadingLikes ?? this.isLoadingLikes,
      hasMoreLikes: hasMoreLikes ?? this.hasMoreLikes,
      likesError: clearLikesError ? null : likesError ?? this.likesError,
    );
  }
}
