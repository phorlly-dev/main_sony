import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Api.c.dart';
import 'package:main_sony/controllers/Category.c.dart';
import 'package:main_sony/controllers/Connection.c.dart';
import 'package:main_sony/controllers/Page.c.dart';
import 'package:main_sony/controllers/Post.c.dart';
import 'package:main_sony/views/screens/Home.s.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register controllers BEFORE runApp
  Get.put(ApiProvider());
  Get.put(ConnectionController());
  Get.put(PostController());
  Get.put(PageControllerX());
  Get.put(CategoryController());
  // Get.put(MediaController());

  runApp(const StarterScreen());
}

class StarterScreen extends StatelessWidget {
  const StarterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Get.isDarkMode
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: Get.isDarkMode ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: Get.isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return GetMaterialApp(
      title: 'Flutter Demo',
      locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system, // Follow system or allow toggling
      home: const HomeScreen(),
      // home: TestconnectionScreen(title: "Test Connection"),
    );
  }
}
