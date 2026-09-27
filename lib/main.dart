import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/services/ad_service.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/shared_preferences_service.dart';
import 'data/local/hive_service.dart';

Future<void> main() async {
  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge modern system bar styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // 2. Initialize Hive local storage
  final hiveService = HiveService();
  await hiveService.init();

  // 3. Initialize SharedPreferences
  final sharedPrefsService = await SharedPreferencesService.init();

  // 4. Initialize LocalStorageService facade
  final localStorageService = LocalStorageService(
    hiveService: hiveService,
    prefsService: sharedPrefsService,
  );

  // 5. Initialize Google Mobile Ads SDK
  final adService = AdService();
  await adService.init();

  // Register foundational storage and ad services into GetX
  Get.put<HiveService>(hiveService, permanent: true);
  Get.put<SharedPreferencesService>(sharedPrefsService, permanent: true);
  Get.put<LocalStorageService>(localStorageService, permanent: true);
  Get.put<AdService>(adService, permanent: true);

  // 6. Run the application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
