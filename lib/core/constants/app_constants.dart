class AppConstants {
  AppConstants._();

  static const String appName = 'Feastly';
  static const String appTagline = 'Food. Fast. Flawless.';
  static const String currency = '৳';
  static const String currencyCode = 'BDT';

  // SharedPreferences keys
  static const String keySeenOnboarding = 'seen_onboarding';
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyThemeMode = 'theme_mode';

  // Animation durations
  static const int splashDuration = 2800;
  static const int animFast = 200;
  static const int animNormal = 350;
  static const int animSlow = 600;

  // Pagination
  static const int pageSize = 10;

  // Cart
  static const double freeDeliveryThreshold = 500.0;
  static const double platformFee = 15.0;

  // Dummy auth
  static const String demoEmail = 'demo@feastly.com';
  static const String demoPassword = 'demo1234';
}
