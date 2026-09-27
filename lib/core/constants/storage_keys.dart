class StorageKeys {
  StorageKeys._();

  // Hive Box Names
  static const String transferHistoryBox = 'transfer_history_box';
  static const String deviceMetadataBox = 'device_metadata_box';
  static const String transferMetadataBox = 'transfer_metadata_box';

  // SharedPreferences Keys
  static const String onboardingCompleted = 'pref_onboarding_completed';
  static const String deviceCustomName = 'pref_device_custom_name';
  static const String autoAcceptTransfers = 'pref_auto_accept_transfers';
  static const String saveDirectoryPath = 'pref_save_directory_path';
  static const String preferredThemeMode = 'pref_theme_mode';
  static const String totalTransferredBytes = 'pref_total_transferred_bytes';
}
