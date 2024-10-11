// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Student Grade Management System`
  String get appTitle {
    return Intl.message(
      'Student Grade Management System',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Grades Management`
  String get gradesManagement {
    return Intl.message(
      'Grades Management',
      name: 'gradesManagement',
      desc: '',
      args: [],
    );
  }

  /// `Historical Events`
  String get historicalEvents {
    return Intl.message(
      'Historical Events',
      name: 'historicalEvents',
      desc: '',
      args: [],
    );
  }

  /// `Personal Center`
  String get personalCenter {
    return Intl.message(
      'Personal Center',
      name: 'personalCenter',
      desc: '',
      args: [],
    );
  }

  /// `Shenhuifu`
  String get shenhuifuTitle {
    return Intl.message(
      'Shenhuifu',
      name: 'shenhuifuTitle',
      desc: '',
      args: [],
    );
  }

  /// `Famous Quotes`
  String get famousQuotesTitle {
    return Intl.message(
      'Famous Quotes',
      name: 'famousQuotesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Please enter student ID to search`
  String get searchStudentId {
    return Intl.message(
      'Please enter student ID to search',
      name: 'searchStudentId',
      desc: '',
      args: [],
    );
  }

  /// `Student Name`
  String get studentName {
    return Intl.message(
      'Student Name',
      name: 'studentName',
      desc: '',
      args: [],
    );
  }

  /// `Class`
  String get className {
    return Intl.message(
      'Class',
      name: 'className',
      desc: '',
      args: [],
    );
  }

  /// `Total Credits`
  String get totalCredits {
    return Intl.message(
      'Total Credits',
      name: 'totalCredits',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get noData {
    return Intl.message(
      'No data available',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Please enter student ID to search`
  String get enterStudentIdToSearch {
    return Intl.message(
      'Please enter student ID to search',
      name: 'enterStudentIdToSearch',
      desc: '',
      args: [],
    );
  }

  /// `Historical Events Today`
  String get historicalToday {
    return Intl.message(
      'Historical Events Today',
      name: 'historicalToday',
      desc: '',
      args: [],
    );
  }

  /// `Today is`
  String get todayIs {
    return Intl.message(
      'Today is',
      name: 'todayIs',
      desc: '',
      args: [],
    );
  }

  /// `Historical events that occurred today:`
  String get historicalEventsOccurred {
    return Intl.message(
      'Historical events that occurred today:',
      name: 'historicalEventsOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Account Management`
  String get accountManagement {
    return Intl.message(
      'Account Management',
      name: 'accountManagement',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Notebook`
  String get notebook {
    return Intl.message(
      'Notebook',
      name: 'notebook',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Enter Old Password`
  String get enterOldPassword {
    return Intl.message(
      'Enter Old Password',
      name: 'enterOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter New Password`
  String get enterNewPassword {
    return Intl.message(
      'Enter New Password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password and confirmation do not match`
  String get passwordMismatch {
    return Intl.message(
      'New password and confirmation do not match',
      name: 'passwordMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get passwordEmpty {
    return Intl.message(
      'Password cannot be empty',
      name: 'passwordEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully, please log in again`
  String get passwordChangeSuccess {
    return Intl.message(
      'Password changed successfully, please log in again',
      name: 'passwordChangeSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to change password, please try again`
  String get passwordChangeFailure {
    return Intl.message(
      'Failed to change password, please try again',
      name: 'passwordChangeFailure',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Logout`
  String get confirmLogout {
    return Intl.message(
      'Confirm Logout',
      name: 'confirmLogout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Notebook`
  String get notebookTitle {
    return Intl.message(
      'Notebook',
      name: 'notebookTitle',
      desc: '',
      args: [],
    );
  }

  /// `Notebook`
  String get notebook_title {
    return Intl.message(
      'Notebook',
      name: 'notebook_title',
      desc: '',
      args: [],
    );
  }

  /// `Edit Note`
  String get edit_note {
    return Intl.message(
      'Edit Note',
      name: 'edit_note',
      desc: '',
      args: [],
    );
  }

  /// `Add Note`
  String get add_note {
    return Intl.message(
      'Add Note',
      name: 'add_note',
      desc: '',
      args: [],
    );
  }

  /// `Enter note title`
  String get input_note_title {
    return Intl.message(
      'Enter note title',
      name: 'input_note_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter note content`
  String get input_note_content {
    return Intl.message(
      'Enter note content',
      name: 'input_note_content',
      desc: '',
      args: [],
    );
  }

  /// `Note saved successfully`
  String get note_saved {
    return Intl.message(
      'Note saved successfully',
      name: 'note_saved',
      desc: '',
      args: [],
    );
  }

  /// `Note deleted`
  String get note_deleted {
    return Intl.message(
      'Note deleted',
      name: 'note_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Note pinned`
  String get note_pinned {
    return Intl.message(
      'Note pinned',
      name: 'note_pinned',
      desc: '',
      args: [],
    );
  }

  /// `Title and content cannot be empty`
  String get title_content_empty {
    return Intl.message(
      'Title and content cannot be empty',
      name: 'title_content_empty',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Pin`
  String get pin {
    return Intl.message(
      'Pin',
      name: 'pin',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message(
      'Profile',
      name: 'profileTitle',
      desc: 'Title - Profile page',
      args: [],
    );
  }

  /// `Student ID: `
  String get studentId {
    return Intl.message(
      'Student ID: ',
      name: 'studentId',
      desc: 'Label for student ID',
      args: [],
    );
  }

  /// `Class: `
  String get studentClass {
    return Intl.message(
      'Class: ',
      name: 'studentClass',
      desc: 'Label for student class',
      args: [],
    );
  }

  /// `Email: `
  String get studentEmail {
    return Intl.message(
      'Email: ',
      name: 'studentEmail',
      desc: 'Label for student email',
      args: [],
    );
  }

  /// `Update Avatar`
  String get updateAvatar {
    return Intl.message(
      'Update Avatar',
      name: 'updateAvatar',
      desc: 'Button - Update avatar',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: 'Loading status message',
      args: [],
    );
  }

  /// `Failed to fetch`
  String get failedToFetch {
    return Intl.message(
      'Failed to fetch',
      name: 'failedToFetch',
      desc: 'Error message when data fetch fails',
      args: [],
    );
  }

  /// `Not logged in`
  String get notLoggedIn {
    return Intl.message(
      'Not logged in',
      name: 'notLoggedIn',
      desc: 'Status message for not logged in',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: 'Title for the login page',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: 'Label for the username input field',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: 'Label for the password input field',
      args: [],
    );
  }

  /// `Login successful!`
  String get loginSuccess {
    return Intl.message(
      'Login successful!',
      name: 'loginSuccess',
      desc: 'Message displayed when login is successful',
      args: [],
    );
  }

  /// `Login failed: {message}`
  String get loginFailed {
    return Intl.message(
      'Login failed: {message}',
      name: 'loginFailed',
      desc: 'Message displayed when login fails',
      args: [],
    );
  }

  /// `No account? Click to register`
  String get noAccountRegister {
    return Intl.message(
      'No account? Click to register',
      name: 'noAccountRegister',
      desc: 'Prompt for user to register if they don\'t have an account',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotPassword',
      desc: 'Prompt for user to reset their password',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'messages'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
