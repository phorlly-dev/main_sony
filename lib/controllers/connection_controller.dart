import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/post_list_controller.dart';

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

    ever(isOnline, (bool online) {
      if (online) {
        refreshCurrentPage();
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
