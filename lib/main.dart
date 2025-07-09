import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/category_controller.dart';
import 'package:main_sony/controllers/connection_controller.dart';
import 'package:main_sony/controllers/page_controller.dart';
import 'package:main_sony/controllers/post_controller.dart';
import 'package:main_sony/utils/constants.dart';
import 'package:main_sony/views/screens/index.dart';
import 'package:main_sony/views/screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register controllers BEFORE runApp
  Get.put(ConnectionController());
  Get.put(PostController());
  Get.put(PageControllerX());
  Get.put(CategoryController());

  runApp(const StarterScreen());
}

class StarterScreen extends StatelessWidget {
  const StarterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash",
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/dashboard', page: () => IndexScreen()),
      ],
      theme: lightTheme, // Default light theme
      darkTheme: darkTheme, // Dark theme
      themeMode: ThemeMode.system, // Follow system or allow toggling
      home: const IndexScreen(),
    );
  }
}
