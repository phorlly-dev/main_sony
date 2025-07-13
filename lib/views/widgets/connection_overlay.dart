import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/connection_controller.dart';
import 'package:main_sony/views/widgets/not_found.dart';

class ConnectionOverlay extends StatelessWidget {
  const ConnectionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final ConnectionController connection = Get.find();

    return Obx(() {
      if (!connection.isOnline.value) {
        // Block all taps and show loading or "No Internet"
        return AbsorbPointer(
          absorbing: true,
          child: Container(
            color: Colors.black.withValues(alpha: .8),
            alignment: Alignment.center,
            child: NotFound(),
          ),
        );
      }

      // If online, do not show anything
      return SizedBox.shrink();
    });
  }
}
