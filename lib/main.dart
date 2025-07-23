import 'package:get/get.dart';
import 'package:main_sony/views/export_views.dart';
import 'controllers/export_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register controllers BEFORE runApp
  Get.put(ConnectionController());
  Get.put(PostListController());
  Get.put(PageControllerX());
  Get.put(MenuItemController());
  Get.put(ImageSliderController());

  await dotenv.load(fileName: ".env");
  final key = dotenv.env['OPENAI_API_KEY']!;
  OpenAI.apiKey = key;

  await ScreenUtil.ensureScreenSize();

  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => const StarterScreen(),
    ),
  );
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
