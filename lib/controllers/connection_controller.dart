import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/state_manager.dart';
import 'package:main_sony/controllers/api_provider.dart';

class ConnectionController extends ApiProvider {
  var isChecking = false.obs;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void onInit() {
    super.onInit();
    _check();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      isOnline.value = result.first != ConnectivityResult.none;
    });
  }

  @override
  void onClose() {
    super.onClose();
    _subscription.cancel();
  }

  Future<void> _check() async {
    isChecking.value = true;
    final result = await Connectivity().checkConnectivity();
    isOnline.value = result.first != ConnectivityResult.none;
    isChecking.value = false;
  }

  void retry() => _check();
}
