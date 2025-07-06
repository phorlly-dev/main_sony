import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Connection.c.dart';
import 'package:main_sony/views/screens/NotFound.s.dart';

class AppRoot extends StatelessWidget {
  final Widget child;
  const AppRoot({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final connection = Get.find<ConnectionController>();
    return Obx(() {
      if (connection.isChecking.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (!connection.isOnline.value) {
        return NotFoundPage(
          onRetry: () => connection.retry(),
          status: connection.isChecking.value,
        );
      }
      return child;
    });
  }
}
