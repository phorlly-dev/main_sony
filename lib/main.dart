import 'package:main_sony/views/export_views.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'controllers/export_controller.dart';

void main() {
  // Optional: for debugging
  BindingBase.debugZoneErrorsAreFatal = true;

  //The guarded zone
  return runZonedGuarded(
    () async {
      // Must be FIRST inside the zone:
      WidgetsFlutterBinding.ensureInitialized();

      await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      // NOTE: Replace with your own app ID from https://www.onesignal.com
      OneSignal.initialize("554a089c-a5ad-4ec6-9741-1063bb2e07e5");
      await OneSignal.Notifications.requestPermission(true);

      //The error handler early
      FlutterError.onError = (details) => FlutterError.presentError(details);

      //Load API Key
      await dotenv.load(fileName: ".env");
      final key = dotenv.env['OPENAI_API_KEY']!;
      OpenAI.apiKey = key;

      // Register GetX controllers, etc.
      Get.put(ConnectionController());
      Get.put(PostListController());
      Get.put(PageControllerX());
      Get.put(MenuItemController());
      Get.put(ImageSliderController());

      //ScreenUtil
      await ScreenUtil.ensureScreenSize();

      //Run app
      return runApp(
        ScreenUtilInit(
          designSize: Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => const MasterScreen(),
        ),
      );
    },
    (error, stack) {
      log('Caught error: $error');
    },
  );
}
