import 'package:main_sony/views/export_views.dart';
import 'package:main_sony/configs/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(Duration(milliseconds: 360));
    MyRouter.appReady.value = true;
    await analytics.logAppOpen();
  }

  @override
  Widget build(BuildContext context) {
    // You can show your logo or animation here
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/images/KT2.png")),
            LoadingAnimation(
              type: LoadingType.staggeredDotsWave,
              label: "Please Wait...",
              themeColor: AppColorRole.warning,
            ),
          ],
        ),
      ),
    );
  }
}
