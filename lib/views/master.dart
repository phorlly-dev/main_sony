import 'package:main_sony/views/export_views.dart';
import 'package:main_sony/router.dart';
import 'package:provider/provider.dart';
import '../utils/theme_manager.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Main SOE',
      locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: context.watch<ThemeManager>().themeMode, // Provider
      routerConfig: router,
    );
  }
}
