import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:main_sony/views/export_views.dart';
import 'package:main_sony/configs/router.dart';
import 'package:provider/provider.dart';
import '../utils/theme_manager.dart';

late FirebaseAnalytics analytics;
late FirebaseAnalyticsObserver observer;

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  void initState() {
    super.initState();
    analytics = FirebaseAnalytics.instance;
    observer = FirebaseAnalyticsObserver(analytics: analytics);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Main SOE'.toUpperCase(),
      locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: context.watch<ThemeManager>().themeMode, // Provider
      routerConfig: router,
    );
  }
}
