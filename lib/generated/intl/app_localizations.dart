import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messages_all.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode?.isEmpty ?? false
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations(locale);
    });
  }

  String get appTitle {
    return Intl.message(
      'Student Grade Management System',
      name: 'appTitle',
      desc: 'The application title',
    );
  }

  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: 'Home screen title',
    );
  }

  String get gradesManagement {
    return Intl.message(
      'Grades Management',
      name: 'gradesManagement',
      desc: 'Grades management section title',
    );
  }

  String get historicalEvents {
    return Intl.message(
      'Historical Events',
      name: 'historicalEvents',
      desc: 'Historical events section title',
    );
  }

  String get personalCenter {
    return Intl.message(
      'Personal Center',
      name: 'personalCenter',
      desc: 'Personal center section title',
    );
  }

  String get shenhuifuTitle {
    return Intl.message(
      'Shenhuifu',
      name: 'shenhuifuTitle',
      desc: 'Title for Shenhuifu section',
    );
  }

  String get famousQuotesTitle {
    return Intl.message(
      'Famous Quotes',
      name: 'famousQuotesTitle',
      desc: 'Title for famous quotes section',
    );
  }

  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: 'Button text to refresh content',
    );
  }

  String get searchStudentId {
    return Intl.message(
      'Please enter student ID to search',
      name: 'searchStudentId',
      desc: 'Prompt to search for a student by ID',
    );
  }

  String get studentName {
    return Intl.message(
      'Student Name',
      name: 'studentName',
      desc: 'Label for student name',
    );
  }

  String get className {
    return Intl.message(
      'Class',
      name: 'className',
      desc: 'Label for class',
    );
  }

  String get totalCredits {
    return Intl.message(
      'Total Credits',
      name: 'totalCredits',
      desc: 'Label for total credits',
    );
  }

  String get noData {
    return Intl.message(
      'No data available',
      name: 'noData',
      desc: 'Message displayed when no data is available',
    );
  }

  String get enterStudentIdToSearch {
    return Intl.message(
      'Please enter student ID to search',
      name: 'enterStudentIdToSearch',
      desc: 'Prompt for entering student ID',
    );
  }

  String get historicalToday => Intl.message(
        'Historical Events Today',
        name: 'historicalToday',
        desc: 'Title for historical events today screen',
      );

  String get todayIs => Intl.message(
        'Today is',
        name: 'todayIs',
        desc: 'Label to indicate the current date',
      );

  String get historicalEventsOccurred => Intl.message(
        'Historical events that occurred today:',
        name: 'historicalEventsOccurred',
        desc: 'Label to show historical events',
      );

  // New localized strings
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: 'Settings section title',
    );
  }

  String get accountManagement {
    return Intl.message(
      'Account Management',
      name: 'accountManagement',
      desc: 'Account management section title',
    );
  }

  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: 'Close button text',
    );
  }

  String get notebook {
    return Intl.message(
      'Notebook',
      name: 'notebook',
      desc: 'Label for notebook section',
    );
  }

  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: 'Change password option',
    );
  }

  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: 'Logout option',
    );
  }

  String get enterOldPassword {
    return Intl.message(
      'Enter Old Password',
      name: 'enterOldPassword',
      desc: 'Prompt for entering old password',
    );
  }

  String get enterNewPassword {
    return Intl.message(
      'Enter New Password',
      name: 'enterNewPassword',
      desc: 'Prompt for entering new password',
    );
  }

  String get confirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'confirmNewPassword',
      desc: 'Prompt for confirming new password',
    );
  }

  String get passwordMismatch {
    return Intl.message(
      'New password and confirmation do not match',
      name: 'passwordMismatch',
      desc: 'Message when passwords do not match',
    );
  }

  String get passwordEmpty {
    return Intl.message(
      'Password cannot be empty',
      name: 'passwordEmpty',
      desc: 'Message when password field is empty',
    );
  }

  String get passwordChangeSuccess {
    return Intl.message(
      'Password changed successfully, please log in again',
      name: 'passwordChangeSuccess',
      desc: 'Message displayed when password change is successful',
    );
  }

  String get passwordChangeFailure {
    return Intl.message(
      'Failed to change password, please try again',
      name: 'passwordChangeFailure',
      desc: 'Message displayed when password change fails',
    );
  }

  String get confirmLogout {
    return Intl.message(
      'Confirm Logout',
      name: 'confirmLogout',
      desc: 'Prompt to confirm logout',
    );
  }

  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutConfirmation',
      desc: 'Confirmation message for logging out',
    );
  }

  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: 'Confirm action button text',
    );
  }

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: 'Cancel action button text',
    );
  }

  String get notebookTitle {
    return Intl.message(
      'Notebook',
      name: 'notebookTitle',
      desc: 'Title of the notebook page',
    );
  }

  String get editNote {
    return Intl.message(
      'Edit Note',
      name: 'editNote',
      desc: 'Edit note dialog title',
    );
  }

  String get addNote {
    return Intl.message(
      'Add Note',
      name: 'addNote',
      desc: 'Add note dialog title',
    );
  }

  String get inputNoteTitle {
    return Intl.message(
      'Enter note title',
      name: 'inputNoteTitle',
      desc: 'Hint for note title input field',
    );
  }

  String get inputNoteContent {
    return Intl.message(
      'Enter note content',
      name: 'inputNoteContent',
      desc: 'Hint for note content input field',
    );
  }

  String get pin {
    return Intl.message(
      '置顶',
      name: 'pin',
      desc: 'Label for pinning a note',
    );
  }

  String get delete {
    return Intl.message(
      '删除',
      name: 'delete',
      desc: 'Label for deleting a note',
    );
  }

  String get noteSaved {
    return Intl.message(
      'Note saved successfully',
      name: 'noteSaved',
      desc: 'Message when a note is saved',
    );
  }

  String get noteDeleted {
    return Intl.message(
      'Note deleted',
      name: 'noteDeleted',
      desc: 'Message when a note is deleted',
    );
  }

  String get notePinned {
    return Intl.message(
      'Note pinned',
      name: 'notePinned',
      desc: 'Message when a note is pinned',
    );
  }

  String get titleContentEmpty {
    return Intl.message(
      'Title and content cannot be empty',
      name: 'titleContentEmpty',
      desc: 'Error message for empty title or content',
    );
  }

  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: 'Save action button text',
    );
  }

  String get profileTitle {
    return Intl.message(
      'Profile',
      name: 'profileTitle',
      desc: 'Title - Profile page',
    );
  }

  String get studentId {
    return Intl.message(
      'Student ID: ',
      name: 'studentId',
      desc: 'Label for student ID',
    );
  }

  String get studentClass {
    return Intl.message(
      'Class: ',
      name: 'studentClass',
      desc: 'Label for student class',
    );
  }

  String get studentEmail {
    return Intl.message(
      'Email: ',
      name: 'studentEmail',
      desc: 'Label for student email',
    );
  }

  String get updateAvatar {
    return Intl.message(
      'Update Avatar',
      name: 'updateAvatar',
      desc: 'Button - Update avatar',
    );
  }

  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: 'Loading status message',
    );
  }

  String get failedToFetch {
    return Intl.message(
      'Failed to fetch',
      name: 'failedToFetch',
      desc: 'Error message when data fetch fails',
    );
  }

  String get notLoggedIn {
    return Intl.message(
      'Not logged in',
      name: 'notLoggedIn',
      desc: 'Status message for not logged in',
    );
  }

  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: 'Title for the login page',
    );
  }

  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: 'Label for the username input field',
    );
  }

  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: 'Label for the password input field',
    );
  }

  String get loginSuccess {
    return Intl.message(
      'Login successful!',
      name: 'loginSuccess',
      desc: 'Message displayed when login is successful',
    );
  }

  String get loginFailed {
    return Intl.message(
      'Login failed: {message}',
      name: 'loginFailed',
      desc: 'Message displayed when login fails',
    );
  }

  String get noAccountRegister {
    return Intl.message(
      'No account? Click to register',
      name: 'noAccountRegister',
      desc: 'Prompt for user to register if they don\'t have an account',
    );
  }

  String get forgotPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotPassword',
      desc: 'Prompt for user to reset their password',
    );
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
