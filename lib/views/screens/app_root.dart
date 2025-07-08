import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/connection_controller.dart';
import 'package:main_sony/views/screens/not_found.dart';

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
        return NotFound(
          onRetry: () => connection.retry(),
          status: connection.isChecking.value,
        );
      }
      return child;
    });
  }
}
