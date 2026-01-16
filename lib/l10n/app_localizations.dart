import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl')
  ];

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get loginWelcome;

  /// No description provided for @loginWelcomeSPA.
  ///
  /// In en, this message translates to:
  /// **'School of Performing Arts'**
  String get loginWelcomeSPA;

  /// No description provided for @loginSocial.
  ///
  /// In en, this message translates to:
  /// **'Or login with'**
  String get loginSocial;

  /// No description provided for @programTitle.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get programTitle;

  /// No description provided for @programSaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get programSaturday;

  /// No description provided for @programSunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get programSunday;

  /// No description provided for @programMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get programMonday;

  /// No description provided for @programTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get programTuesday;

  /// No description provided for @programWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get programWednesday;

  /// No description provided for @programThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get programThursday;

  /// No description provided for @programFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get programFriday;

  /// No description provided for @programNoActivitiesYet.
  ///
  /// In en, this message translates to:
  /// **'We are still working on the program'**
  String get programNoActivitiesYet;

  /// No description provided for @photoTitle.
  ///
  /// In en, this message translates to:
  /// **'Most recent photos'**
  String get photoTitle;

  /// No description provided for @photoSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get photoSeeAll;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditTitle;

  /// No description provided for @profileFirstname.
  ///
  /// In en, this message translates to:
  /// **'Firstname'**
  String get profileFirstname;

  /// No description provided for @profileLastname.
  ///
  /// In en, this message translates to:
  /// **'Lastname'**
  String get profileLastname;

  /// No description provided for @profileAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get profileAge;

  /// No description provided for @profileMajor.
  ///
  /// In en, this message translates to:
  /// **'Major'**
  String get profileMajor;

  /// No description provided for @profileMinor.
  ///
  /// In en, this message translates to:
  /// **'Minor'**
  String get profileMinor;

  /// No description provided for @profilePhotosLiked.
  ///
  /// In en, this message translates to:
  /// **'Photo\'s you liked'**
  String get profilePhotosLiked;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rulesTitle;

  /// No description provided for @rulesRespect.
  ///
  /// In en, this message translates to:
  /// **'Respect'**
  String get rulesRespect;

  /// No description provided for @rulesRespectText.
  ///
  /// In en, this message translates to:
  /// **'At this camp we respect each other, no matter how different we all are. Practically, this means that you consider everyone valuable and that everyone is worth getting to know. In rehearsals, workshops and other activities, everyone has their own opinion (or is forming it) and we prefer an honest answer to the correct one. Furthermore, we respect nature, the employees of Belmont and the leaders of SPA. Together we keep the buildings and the campsite clean of litter and do not have water fights in the buildings.\nPossession and use of alcohol, tobacco, drugs and energy drinks is not allowed throughout the week inside and outside the campsite.'**
  String get rulesRespectText;

  /// No description provided for @rulesUnity.
  ///
  /// In en, this message translates to:
  /// **'Unity'**
  String get rulesUnity;

  /// No description provided for @rulesUnityText.
  ///
  /// In en, this message translates to:
  /// **'We form one group together. No one is left out. The boat is big enough. We don\'t bully each other. We dare to get to know new people. We dare to let other people get to know us. Everyone big or small, fat or thin, tough or shy; everyone is equally valuable in God\'s eyes and God loves everyone just as much. Together we do our utmost to ensure that nothing stands in the way of this.\nWe do nothing that endangers ourselves or others.\nEach participant must be present at each organized program component. The only exception is if you have received permission from the management for this.\nMobile phones, game consoles, laptops, tablets and the like are not used during activities out of respect for each other, for guests and the leaders of the various activities.'**
  String get rulesUnityText;

  /// No description provided for @rulesSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get rulesSafety;

  /// No description provided for @rulesSafetyText.
  ///
  /// In en, this message translates to:
  /// **'A safe environment at camp is important. We mean two forms of safety. Firstly, safely handling oneself, others, materials, and buildings. Additionally, the safety that allows you to be who you are and feel comfortable during the camp.\nLeaving the campsite on your own initiative is not allowed! Furthermore, in case of fire or any other emergency, you should follow the instructions of the leaders.\nMedications that you need will be collected by the leaders at the beginning of the week and provided to you during the week.\nBeing in the sleeping quarters or bathroom of the opposite gender is not allowed. Additionally, during the day, you should not be unnecessarily in your tent or dormitory, but you should be there at night.\nSleep is important for your safety and health. Therefore, between 12:00 a.m. and 7:00 a.m., it should be quiet on the premises. In the tent camps, it should be quiet from 11:00 p.m. onwards.'**
  String get rulesSafetyText;

  /// No description provided for @rulesTrust.
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get rulesTrust;

  /// No description provided for @rulesTrustText.
  ///
  /// In en, this message translates to:
  /// **'The camp consists of a lot of fun and pleasure. However, it may be that you have something on your heart and would like to talk to someone about it. The leaders at this camp are here especially for you. This can be the leaders of your group, but also any other leaders. We would like to listen to you, talk to you or (if you want) pray with you.\nIf you have a problem, discuss it with your group leader or with the head leader of the camp.\n'**
  String get rulesTrustText;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapTitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Dear SPA-goers'**
  String get welcomeTitle;

  /// No description provided for @welcomeText.
  ///
  /// In en, this message translates to:
  /// **'This year marks the 75th edition of SPA. What a time and what a milestone that is. Throughout all these years, there have been many footprints left in Belmont by all the participants who have taken part in the camp. Perhaps your own footprint, or that of your parents or other family members. They all experienced beautiful moments there, made memories, and somehow left a footprint behind.\nNow, let this year\'s theme be about \"Footprint\".\nNo, it\'s not just about the previous 74 editions of SPA, nor is it solely about sustainability. Both themes naturally come into play this year.\nWe will start on Saturday with the REUNION of 75 years of SPA, where we will have the opportunity to meet many former participants and leaders. Throughout the week, we will also focus on sustainability, with a meatless meal and even vegetarian snacks. With this year\'s theme of Footprint, we will primarily look at some important people in the Bible and what they left behind. But we will also contemplate who you are or want to be, and what you want to leave behind: your own footprint!\n\nWe wish you a lot of fun!\nMichel & Roel'**
  String get welcomeText;

  /// No description provided for @weatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherTitle;

  /// No description provided for @weatherUpcomingHours.
  ///
  /// In en, this message translates to:
  /// **'Upcoming 12 hours'**
  String get weatherUpcomingHours;

  /// No description provided for @weatherUpcomingDays.
  ///
  /// In en, this message translates to:
  /// **'Upcoming days'**
  String get weatherUpcomingDays;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginNoAccount;

  /// No description provided for @loginRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get loginRegister;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get loginEmailHint;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get loginEmailRequired;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Email is invalid'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordHint;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get loginPasswordRequired;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong credentials'**
  String get loginWrongCredentials;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive a password reset link.'**
  String get resetPasswordInstruction;

  /// No description provided for @resetPasswordSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Email'**
  String get resetPasswordSendButton;

  /// No description provided for @resetPasswordBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get resetPasswordBackToLogin;

  /// No description provided for @resetPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset email: {error}'**
  String resetPasswordFailed(Object error);

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent!'**
  String get resetPasswordSuccess;

  /// No description provided for @tasksTab.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTab;

  /// No description provided for @tasksNoTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks assigned.'**
  String get tasksNoTasks;

  /// No description provided for @tasksLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get tasksLocation;

  /// No description provided for @tasksDayTime.
  ///
  /// In en, this message translates to:
  /// **'{day} - {time}'**
  String tasksDayTime(Object day, Object time);

  /// No description provided for @tasksDetails.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get tasksDetails;

  /// No description provided for @tasksAssignedUsers.
  ///
  /// In en, this message translates to:
  /// **'Assigned Users'**
  String get tasksAssignedUsers;

  /// No description provided for @tasksNoAssignedUsers.
  ///
  /// In en, this message translates to:
  /// **'No users assigned to this task.'**
  String get tasksNoAssignedUsers;

  /// No description provided for @tasksTent.
  ///
  /// In en, this message translates to:
  /// **'Tent'**
  String get tasksTent;

  /// No description provided for @tasksMajor.
  ///
  /// In en, this message translates to:
  /// **'Major'**
  String get tasksMajor;

  /// No description provided for @tasksAllTasks.
  ///
  /// In en, this message translates to:
  /// **'All Tasks'**
  String get tasksAllTasks;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountButton;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountDescription;

  /// No description provided for @deleteAccountCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deleteAccountCancel;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAccountConfirm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
