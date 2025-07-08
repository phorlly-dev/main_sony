import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/post_controller.dart';

class ConnectionController extends PostController {
  var isOnline = true.obs;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void onInit() {
    super.onInit();
    _check();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      isOnline.value = result.first != ConnectivityResult.none;
    });

    if (isOnline.value) {
      refreshCurrentPage();
    }
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
