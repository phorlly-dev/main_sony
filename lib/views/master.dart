import 'package:main_sony/views/export_views.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Main Sony',
      locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash",
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/view-posts', page: () => IndexScreen()),
        GetPage(name: '/ai-chatbots', page: () => AiChatbotScreen()),
      ],
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system, // Follow system or allow toggling
      home: const IndexScreen(),
    );
  }
}
