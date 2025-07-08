import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/connection_controller.dart';
import 'package:main_sony/views/widgets/not_found.dart';

class AppRoot extends StatelessWidget {
  final Widget child;

  const AppRoot({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final connection = Get.find<ConnectionController>();
    return Obx(() {
      final isOnline = connection.isOnline.value;

      if (!isOnline) {
        return NotFound();
      }

      return child;
    });
  }
}
