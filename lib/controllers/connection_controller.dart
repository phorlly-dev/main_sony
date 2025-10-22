import 'package:get/get.dart';
import 'export_controller.dart';

class ConnectionController extends PostListController {
  var isOnline = true.obs;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  // In ConnectionController:
  // void _showOfflineDialog() {
  //   if (!Get.isDialogOpen!) {
  //     Get.dialog(
  //       AlertDialog(
  //         title: Text('Tidak ada koneksi'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(Icons.wifi_off, size: 48, color: Colors.red),
  //             SizedBox(height: 16),
  //             Text('Periksa koneksi internet Anda.'),
  //           ],
  //         ),
  //         elevation: .1,
  //       ),
  //       barrierDismissible: false,
  //     );
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
    _check();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      isOnline.value = result.first != ConnectivityResult.none;
      // if (!isOnline.value) {
      //   _showOfflineDialog();
      // } else {
      //   if (Get.isDialogOpen!) Get.back();
      // }
    });

    ever(isOnline, (bool online) async {
      if (online) {
        await refreshKeepingPosition();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    _subscription.cancel();
  }

  Future<void> _check() async {
    final result = await Connectivity().checkConnectivity();
    isOnline.value = result.first != ConnectivityResult.none;
  }
}
