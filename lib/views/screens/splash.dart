import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/views/widgets/loading_animation.dart';

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

  void _initApp() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate loading
    // Add your app start logic here (e.g., check login, fetch config)
    // Then navigate:
    Get.toNamed("/dashboard"); // or whatever your initial route is
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
            LoadingAnimation(type: 5),
          ],
        ),
      ),
    );
  }
}
