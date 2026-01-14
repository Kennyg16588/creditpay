import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  /// Initialize Remote Config
  Future<void> initialize() async {
    try {
      // 1. Set configuration settings
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval:
              kDebugMode ? Duration.zero : const Duration(hours: 1),
        ),
      );

      // 2. Set default values
      // You should define your variables and their default values here
      await _remoteConfig.setDefaults(const {
        "show_promotion_banner": false,
        "support_email": "support@creditpay.com",
        "loan_interest_rate": 0.05,
        "app_primary_color": "#142B71",
      });

      // 3. Fetch and activate values
      await fetchAndActivate();
    } catch (e) {
      debugPrint("❌ Remote Config Initialization Error: $e");
    }
  }

  /// Fetch and Activate terbaru
  Future<void> fetchAndActivate() async {
    bool updated = await _remoteConfig.fetchAndActivate();
    if (updated) {
      debugPrint("✅ Remote Config Updated and Activated");
    } else {
      debugPrint("ℹ️ Remote Config: Use cached values");
    }
  }

  // Helper methods to get values
  bool getBool(String key) => _remoteConfig.getBool(key);
  String getString(String key) => _remoteConfig.getString(key);
  double getDouble(String key) => _remoteConfig.getDouble(key);
  int getInt(String key) => _remoteConfig.getInt(key);

  /// Example of getting a specific value with logic
  bool get showPromotionBanner => getBool("show_promotion_banner");
  String get supportEmail => getString("support_email");
  double get loanInterestRate => getDouble("loan_interest_rate");
}
