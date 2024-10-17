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

  String get fileManagement {
    return Intl.message(
      'File management',
      name: 'fileManagement',
      desc: 'Label for fileManagement section',
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
      'Pin',
      name: 'pin',
      desc: 'Label for pinning a note',
    );
  }

  String get delete {
    return Intl.message(
      'Delete',
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

  String get appBarTitle {
    return Intl.message(
      'Student Registration',
      name: 'appBarTitle',
      desc: 'Title for the student registration page',
    );
  }

  String get step1Title {
    return Intl.message(
      'Step 1',
      name: 'step1Title',
      desc: 'Title for step 1 of the registration process',
    );
  }

  String get step2Title {
    return Intl.message(
      'Step 2',
      name: 'step2Title',
      desc: 'Title for step 2 of the registration process',
    );
  }

  String get step3Title {
    return Intl.message(
      'Step 3',
      name: 'step3Title',
      desc: 'Title for step 3 of the registration process',
    );
  }

  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: 'Label for confirm password input field',
    );
  }

  String get studentIdHint {
    return Intl.message(
      'Please enter student ID',
      name: 'studentIdHint',
      desc: 'Hint text for student ID input field',
    );
  }

  String get passwordHint {
    return Intl.message(
      'Please enter password',
      name: 'passwordHint',
      desc: 'Hint text for password input field',
    );
  }

  String get classNameId {
    return Intl.message('Class',
        name: 'classNameId',
        desc: 'ClassNameId as in a group of students, not a programming');
  }

  String get passwordMismatchHint {
    return Intl.message(
      'The two passwords do not match',
      name: 'passwordMismatchHint',
      desc: 'Error message when passwords do not match',
    );
  }

  String get classNameHint {
    return Intl.message(
      'Please enter class',
      name: 'classNameHint',
      desc: 'Hint text for class input field',
    );
  }

  String get studentNameHint {
    return Intl.message(
      'Please enter name',
      name: 'studentNameHint',
      desc: 'Hint text for name input field',
    );
  }

  String get selectTeacher {
    return Intl.message(
      'Select Teacher',
      name: 'selectTeacher',
      desc: 'Label for selecting a teacher',
    );
  }

  String get selectTeacherHint {
    return Intl.message(
      'Please select a teacher',
      name: 'selectTeacherHint',
      desc: 'Hint text for selecting a teacher',
    );
  }

  String get qqEmail {
    return Intl.message(
      'QQ Email',
      name: 'qqEmail',
      desc: 'Label for QQ email input field',
    );
  }

  String get qqEmailHint {
    return Intl.message(
      'Please enter a valid QQ email',
      name: 'qqEmailHint',
      desc: 'Hint text for QQ email input field',
    );
  }

  String get verificationCode {
    return Intl.message(
      'Verification Code',
      name: 'verificationCode',
      desc: 'Label for verification code input field',
    );
  }

  String get sendVerificationCode {
    return Intl.message(
      'Send Code',
      name: 'sendVerificationCode',
      desc: 'Button text for sending verification code',
    );
  }

  String get verificationCodeHint {
    return Intl.message(
      'Please enter the verification code',
      name: 'verificationCodeHint',
      desc: 'Hint text for verification code input field',
    );
  }

  String get registerFailed {
    return Intl.message(
      'Registration Failed',
      name: 'registerFailed',
      desc: 'Message for registration failure',
    );
  }

  String get step1Failed {
    return Intl.message(
      'Step 1 registration failed, please check input',
      name: 'step1Failed',
      desc: 'Error message for step 1 failure',
    );
  }

  String get step2Failed {
    return Intl.message(
      'Step 2 registration failed, please check input',
      name: 'step2Failed',
      desc: 'Error message for step 2 failure',
    );
  }

  String get step3Failed {
    return Intl.message(
      'Step 3 registration failed, please check input',
      name: 'step3Failed',
      desc: 'Error message for step 3 failure',
    );
  }

  String get usernameExists {
    return Intl.message(
      'Student ID already registered',
      name: 'usernameExists',
      desc: 'Message when student ID is already registered',
    );
  }

  String get usernameExistsHint {
    return Intl.message(
      'Student ID already registered, please use a different ID',
      name: 'usernameExistsHint',
      desc: 'Hint message when student ID is already registered',
    );
  }

  String get classInfoMissing {
    return Intl.message(
      'Class information cannot be empty',
      name: 'classInfoMissing',
      desc: 'Message when class information is missing',
    );
  }

  String get teacherSelectionError {
    return Intl.message(
      'Please select a valid teacher',
      name: 'teacherSelectionError',
      desc: 'Error message when no valid teacher is selected',
    );
  }

  String get registrationSuccess {
    return Intl.message(
      'Registration Successful',
      name: 'registrationSuccess',
      desc: 'Message when registration is successful',
    );
  }

  String get verificationCodeSent {
    return Intl.message(
      'Verification code sent to your QQ email',
      name: 'verificationCodeSent',
      desc: 'Message when verification code is sent successfully',
    );
  }

  String get verificationCodeSendFailed {
    return Intl.message(
      'Failed to send verification code, please try again',
      name: 'verificationCodeSendFailed',
      desc: 'Message when verification code sending fails',
    );
  }

  String get verificationCodeError {
    return Intl.message(
      'Invalid or expired verification code',
      name: 'verificationCodeError',
      desc: 'Message when verification code is invalid or expired',
    );
  }

  String get checkInput {
    return Intl.message(
      'Registration failed, please check input',
      name: 'checkInput',
      desc: 'Message when registration input is incorrect',
    );
  }

  String get enterEmail {
    return Intl.message(
      'Please enter QQ email first',
      name: 'enterEmail',
      desc: 'Message when email input is missing',
    );
  }

  String get checkUserEmailError {
    return Intl.message(
      'Failed to check user email, please try again',
      name: 'checkUserEmailError',
      desc: 'Error message when checking user email fails',
    );
  }

  String checkUserEmailFailure(String error) {
    return Intl.message(
      'Check user email failed: $error',
      name: 'checkUserEmailFailure',
      args: [error],
      desc: 'Detailed error message for email check failure',
      examples: const {'error': 'Network timeout'},
    );
  }

  String get bindEmailSuccess {
    return Intl.message(
      'Email bound successfully',
      name: 'bindEmailSuccess',
      desc: 'Message shown when email is bound successfully',
    );
  }

  String get bindEmailFailure {
    return Intl.message(
      'Failed to bind email, please try again',
      name: 'bindEmailFailure',
      desc: 'Message shown when binding email fails',
    );
  }

  String get userNotFound {
    return Intl.message(
      'User not found, please register first',
      name: 'userNotFound',
      desc: 'Message shown when user is not found',
    );
  }

  String get emailCannotBeEmpty {
    return Intl.message(
      'Email cannot be empty',
      name: 'emailCannotBeEmpty',
      desc: 'Message shown when email input is empty',
    );
  }

  String get sendVerificationCodeFailure {
    return Intl.message(
      'Failed to send verification code, please try again',
      name: 'sendVerificationCodeFailure',
      desc: 'Message shown when sending verification code fails',
    );
  }

  String get resetPasswordSuccess {
    return Intl.message(
      'Password reset successfully, please log in with the new password',
      name: 'resetPasswordSuccess',
      desc: 'Message shown when password is reset successfully',
    );
  }

  String get resetPasswordFailure {
    return Intl.message(
      'Failed to reset password, please try again',
      name: 'resetPasswordFailure',
      desc: 'Message shown when password reset fails',
    );
  }

  String get bindEmailDialogTitle {
    return Intl.message(
      'Bind Email',
      name: 'bindEmailDialogTitle',
      desc: 'Title of the bind email dialog',
    );
  }

  String get bindEmailDialogContent {
    return Intl.message(
      'Please enter your QQ email to bind',
      name: 'bindEmailDialogContent',
      desc: 'Content of the bind email dialog',
    );
  }

  String get verificationCodeLabel {
    return Intl.message(
      'Verification Code',
      name: 'verificationCodeLabel',
      desc: 'Label for the verification code input field',
    );
  }

  String get newPasswordLabel {
    return Intl.message(
      'New Password',
      name: 'newPasswordLabel',
      desc: 'Label for the new password input field',
    );
  }

  String get sendVerificationCodeDialogTitle {
    return Intl.message(
      'Verify Email',
      name: 'sendVerificationCodeDialogTitle',
      desc: 'Title of the send verification code dialog',
    );
  }

  String sendingVerificationCodeToEmail(String email) {
    return Intl.message(
      'Sending verification code to your email $email',
      name: 'sendingVerificationCodeToEmail',
      args: [email],
      desc: 'Message shown when sending a verification code to a user\'s email',
    );
  }

  String enterVerificationCodeSentToEmail(String email) {
    return Intl.message(
      'Please enter the verification code sent to your email $email',
      name: 'enterVerificationCodeSentToEmail',
      args: [email],
      desc:
          'Message prompting the user to enter the verification code sent to their email',
    );
  }

  String get errorDialogTitle {
    return Intl.message(
      'Error',
      name: 'errorDialogTitle',
      desc: 'Title for the error dialog',
    );
  }

  String get successDialogTitle {
    return Intl.message(
      'Success',
      name: 'successDialogTitle',
      desc: 'Title for the success dialog',
    );
  }

  String get nextStep {
    return Intl.message(
      'Next Step',
      name: 'nextStep',
      desc: 'Text for the next step button',
    );
  }

  String get resetPasswordButton {
    return Intl.message(
      'Verify and Reset Password',
      name: 'resetPasswordButton',
      desc: 'Text for the reset password button',
    );
  }

  String get studentIdLabel {
    return Intl.message(
      'Student ID',
      name: 'studentIdLabel',
      desc: 'Label for the student ID input field',
    );
  }

  String get enterQqEmailToBind {
    return Intl.message(
      '请输入你的QQ邮箱以进行绑定',
      name: 'enterQqEmailToBind',
      desc: '提示用户输入QQ邮箱进行绑定',
    );
  }

  String get fieldsCannotBeEmpty {
    return Intl.message(
      'The email address, verification code, and new password cannot be empty',
      name: fieldsCannotBeEmpty,
      desc:
          'Prompts the user that the email address, verification code, and new password cannot be empty',
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
