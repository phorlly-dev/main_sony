import 'package:firebase_core/firebase_core.dart';
import 'package:main_sony/utils/notification_prefs.dart';
import 'package:main_sony/utils/theme_manager.dart';
import 'package:main_sony/views/export_views.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/export_controller.dart';
import 'firebase_options.dart';

class Configure {
  static void appConfig() {
    BindingBase.debugZoneErrorsAreFatal = true;

    //The guarded zone
    runZonedGuarded(
      () async {
        // Must be FIRST inside the zone:
        WidgetsFlutterBinding.ensureInitialized();

        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

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
        throw Exception('Caught error: $error/$stack');
      },
    );
  }

  static Widget initApp() => ChangeNotifierProvider(
    create: (_) => ThemeManager(),
    child: ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => const MasterScreen(),
    ),
  );

  static void initControllers() {
    Get.put(PostController());
    Get.put(PageControllerX());
    Get.put(MenuItemController());
    Get.put(ImageSliderController());
  }

  static Future<void> initOneSignal() async {
    await NotificationPrefs.init();

    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("554a089c-a5ad-4ec6-9741-1063bb2e07e5");

    await NotificationPrefs.syncToOneSignal();

    // Optional: associate a user id so you can target from backend
    // await OneSignal.login('external_user_id');
  }
}
