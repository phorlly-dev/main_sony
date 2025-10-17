import 'package:main_sony/utils/notification_prefs.dart';
import 'package:main_sony/utils/theme_manager.dart';
import 'package:main_sony/views/export_views.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'controllers/export_controller.dart';

void appConfig() {
  //The guarded zone
  return runZonedGuarded(
    () async {
      // Must be FIRST inside the zone:
      WidgetsFlutterBinding.ensureInitialized();

      //init OneSignal
      await initOneSignal();

      //The error handler early
      FlutterError.onError = (details) => FlutterError.presentError(details);

      //Load API Key
      // await dotenv.load(fileName: ".env");
      // final key = dotenv.env['OPENAI_API_KEY']!;
      // OpenAI.apiKey = key;

      // Register GetX controllers, etc.
      initControllers();

      //ScreenUtil
      await ScreenUtil.ensureScreenSize();

      //Run app
      runApp(initApp());
    },
    (error, stack) {
      log('Caught error: $error');
      throw Exception('Caught error: $error');
    },
  );
}

Widget initApp() {
  return ChangeNotifierProvider(
    create: (_) => ThemeManager(),
    child: ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => const MasterScreen(),
    ),
  );
}

void initControllers() {
  Get.put(ConnectionController());
  Get.put(PostListController());
  Get.put(PageControllerX());
  Get.put(MenuItemController());
  Get.put(ImageSliderController());
}

Future<void> initOneSignal() async {
  await NotificationPrefs.init();

  await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("554a089c-a5ad-4ec6-9741-1063bb2e07e5");

  // Ask for permission (iOS) / subscribe (Android auto)
  await OneSignal.Notifications.requestPermission(true);

  await NotificationPrefs.syncToOneSignal();

  // Optional: associate a user id so you can target from backend
  // await OneSignal.login('external_user_id');
}
