class AppConstants {
  static const String appName = 'Rumour';
  static const String appVersion = '1.0.0';

  // Room code settings
  static const int minRoomCodeLength = 4;
  static const int maxRoomCodeLength = 6;

  // Message settings
  static const int messagesPerPage = 30;
  static const Duration messageLoadTimeout = Duration(seconds: 10);

  // API settings
  static const Duration apiTimeout = Duration(seconds: 15);
  static const String randomUserApiUrl = 'https://randomuser.me/api';

  // UI settings
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
}
