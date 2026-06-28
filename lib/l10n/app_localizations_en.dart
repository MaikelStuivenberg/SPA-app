// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginWelcome => 'Welcome to';

  @override
  String get loginWelcomeSPA => 'School of Performing Arts';

  @override
  String get loginSocial => 'Or login with';

  @override
  String get programTitle => 'Program';

  @override
  String get programSaturday => 'Saturday';

  @override
  String get programSunday => 'Sunday';

  @override
  String get programMonday => 'Monday';

  @override
  String get programTuesday => 'Tuesday';

  @override
  String get programWednesday => 'Wednesday';

  @override
  String get programThursday => 'Thursday';

  @override
  String get programFriday => 'Friday';

  @override
  String get programNoActivitiesYet => 'We are still working on the program';

  @override
  String get photoTitle => 'Photo albums';

  @override
  String get photoAlbumPhotosTitle => 'Photos';

  @override
  String get photoAlbumFavorites => 'Your favorites';

  @override
  String get photoAlbumSortShowNewest => 'Show newest first';

  @override
  String get photoAlbumSortShowOldest => 'Show oldest first';

  @override
  String get photoAlbumsEmpty =>
      'We\'re busy adding photos from camp! Check back soon. :)';

  @override
  String photoAlbumPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return '$_temp0';
  }

  @override
  String get photoSeeAll => 'See all';

  @override
  String get photoSelectionCancel => 'Cancel selection';

  @override
  String photoSelectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String get photoSelectionLike => 'Like';

  @override
  String get photoSelectionUnlike => 'Unlike';

  @override
  String get photoSelectionDownload => 'Download';

  @override
  String get photoSelectionSend => 'Send';

  @override
  String photoBulkDownloadSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos saved to your downloads folder.',
      one: '1 photo saved to your downloads folder.',
    );
    return '$_temp0';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get profileFirstname => 'Firstname';

  @override
  String get profileLastname => 'Lastname';

  @override
  String get profileAge => 'Age';

  @override
  String get profileMajor => 'Major';

  @override
  String get profileMinor => 'Minor';

  @override
  String get profilePhotosLiked => 'Photo\'s you liked';

  @override
  String get profilePhotosLikedEmpty =>
      'You haven\'t liked any photos yet — tap the heart on a photo to save it here!';

  @override
  String get rulesTitle => 'Rules';

  @override
  String get rulesScrollHint => 'Scroll for more';

  @override
  String get rulesRespect => 'Respect';

  @override
  String get rulesRespectText =>
      'At this camp we respect each other, no matter how different we all are. Practically, this means that you consider everyone valuable and that everyone is worth getting to know. In rehearsals, workshops and other activities, everyone has their own opinion (or is forming it) and we prefer an honest answer to the correct one. Furthermore, we respect nature, the employees of Belmont and the leaders of SPA. Together we keep the buildings and the campsite clean of litter and do not have water fights in the buildings.\nPossession and use of alcohol, tobacco, drugs and energy drinks is not allowed throughout the week inside and outside the campsite.';

  @override
  String get rulesUnity => 'Unity';

  @override
  String get rulesUnityText =>
      'We form one group together. No one is left out. The boat is big enough. We don\'t bully each other. We dare to get to know new people. We dare to let other people get to know us. Everyone big or small, fat or thin, tough or shy; everyone is equally valuable in God\'s eyes and God loves everyone just as much. Together we do our utmost to ensure that nothing stands in the way of this.\nWe do nothing that endangers ourselves or others.\nEach participant must be present at each organized program component. The only exception is if you have received permission from the management for this.\nMobile phones, game consoles, laptops, tablets and the like are not used during activities out of respect for each other, for guests and the leaders of the various activities.';

  @override
  String get rulesSafety => 'Safety';

  @override
  String get rulesSafetyText =>
      'A safe environment at camp is important. We mean two forms of safety. Firstly, safely handling oneself, others, materials, and buildings. Additionally, the safety that allows you to be who you are and feel comfortable during the camp.\nLeaving the campsite on your own initiative is not allowed! Furthermore, in case of fire or any other emergency, you should follow the instructions of the leaders.\nMedications that you need will be collected by the leaders at the beginning of the week and provided to you during the week.\nBeing in the sleeping quarters or bathroom of the opposite gender is not allowed. Additionally, during the day, you should not be unnecessarily in your tent or dormitory, but you should be there at night.\nSleep is important for your safety and health. Therefore, between 12:00 a.m. and 7:00 a.m., it should be quiet on the premises. In the tent camps, it should be quiet from 11:00 p.m. onwards.';

  @override
  String get rulesTrust => 'Trust';

  @override
  String get rulesTrustText =>
      'The camp consists of a lot of fun and pleasure. However, it may be that you have something on your heart and would like to talk to someone about it. The leaders at this camp are here especially for you. This can be the leaders of your group, but also any other leaders. We would like to listen to you, talk to you or (if you want) pray with you.\nIf you have a problem, discuss it with your group leader or with the head leader of the camp.\n';

  @override
  String get mapTitle => 'Map';

  @override
  String get loading => 'Loading...';

  @override
  String get save => 'Save';

  @override
  String get weatherTitle => 'Weather';

  @override
  String get weatherUpcomingHours => 'Upcoming 12 hours';

  @override
  String get weatherUpcomingDays => 'Upcoming days';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginRegister => 'Register';

  @override
  String get loginEmailHint => 'Email address';

  @override
  String get loginEmailRequired => 'Email is required';

  @override
  String get loginEmailInvalid => 'Email is invalid';

  @override
  String get loginPasswordHint => 'Password';

  @override
  String get loginPasswordRequired => 'Password is required';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginWrongCredentials => 'Wrong credentials';

  @override
  String get loginButton => 'Login';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordInstruction =>
      'Enter your email address to receive a password reset link.';

  @override
  String get resetPasswordSendButton => 'Send Reset Email';

  @override
  String get resetPasswordBackToLogin => 'Back to Login';

  @override
  String resetPasswordFailed(Object error) {
    return 'Failed to send reset email: $error';
  }

  @override
  String get resetPasswordSuccess => 'Password reset email sent!';

  @override
  String get tasksTab => 'Tasks';

  @override
  String get tasksNoTasks => 'No tasks assigned.';

  @override
  String get tasksLocation => 'Location';

  @override
  String tasksDayTime(Object day, Object time) {
    return '$day - $time';
  }

  @override
  String get tasksDetails => 'Task Details';

  @override
  String get tasksAssignedUsers => 'Assigned Users';

  @override
  String get tasksNoAssignedUsers => 'No users assigned to this task.';

  @override
  String get tasksTent => 'Tent';

  @override
  String get tasksMajor => 'Major';

  @override
  String get tasksAllTasks => 'All Tasks';

  @override
  String tasksProgress(int completed, int total) {
    return '$completed of $total completed';
  }

  @override
  String get tasksAllDone => 'All tasks completed';

  @override
  String get tasksCompletedSection => 'Completed';

  @override
  String get tasksMarkDone => 'Mark as done';

  @override
  String get tasksUndo => 'Undo';

  @override
  String get deleteAccountButton => 'Delete Account';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountDescription =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get deleteAccountCancel => 'Cancel';

  @override
  String get deleteAccountConfirm => 'Delete';

  @override
  String get registerTitle => 'Join SPA online';

  @override
  String get registerSubtitle =>
      'Create your app account to stay connected during SPA';

  @override
  String get registerEmailHint => 'Email address';

  @override
  String get registerPasswordHint => 'Password';

  @override
  String get registerPasswordConfirmHint => 'Confirm password';

  @override
  String get registerPasswordRequired => 'Password is required';

  @override
  String get registerPasswordMinLength =>
      'Password must be at least 4 characters';

  @override
  String get registerPasswordMismatch => 'Passwords do not match';

  @override
  String get registerButton => 'Sign up';

  @override
  String get onboardingTitle => 'Set up your profile';

  @override
  String get onboardingNameTitle => 'What\'s your name?';

  @override
  String get onboardingNameSubtitle =>
      'We\'ll use this so leaders and friends can find you in the app.';

  @override
  String get onboardingFirstnameRequired => 'First name is required';

  @override
  String get onboardingPhotoTitle => 'Add a profile photo';

  @override
  String get onboardingPhotoSubtitle =>
      'Optional — help your tent mates recognize you!';

  @override
  String get onboardingPhotoSkip => 'Skip for now';

  @override
  String onboardingWelcomeTitle(String name) {
    return 'Hey $name!';
  }

  @override
  String get onboardingWelcomeBody => 'You\'re all set. See you at SPA!';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingLetsGo => 'Let\'s go!';
}
