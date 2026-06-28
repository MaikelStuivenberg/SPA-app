/// Central route path constants for [GoRouter].
class RoutePaths {
  RoutePaths._();

  static const splash = '/';
  static const home = '/home';
  static const program = '/program';
  static const biblestudy = '/biblestudy';
  static const photos = '/photos';
  static const photosAlbum = '/photos/album/:albumId';
  static const favoritesAlbumId = 'favorites';

  static String photosAlbumFor(String albumId) => '/photos/album/$albumId';
  static const rules = '/rules';
  static const map = '/map';
  static const userDetails = '/user';
  static const editUser = '/user/edit';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const weather = '/weather';
  static const resetPassword = '/reset-password';
  static const allTasks = '/program/tasks';
  static const taskDetails = '/program/tasks/details';
}
