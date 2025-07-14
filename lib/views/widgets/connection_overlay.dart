import 'package:get/get.dart';
import '../../controllers/export_controller.dart';
import '../export_views.dart';

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
