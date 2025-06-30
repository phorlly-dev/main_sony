import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';

class ApiProvider extends GetxController {
  final _apiUrl = 'https://soepress.com/wp-json/wp/v2';
  late WordpressClient connx;
  var isLoading = false.obs;
  var hasError = ''.obs;
  final _selectedIndex = 0.obs;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String get apiUrl => _apiUrl; // optional getter
  int get selectedIndex => _selectedIndex.value;

  void openOrCloseDrawer() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void setMenuIndex(int index) {
    _selectedIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    connx = WordpressClient(baseUrl: Uri.parse(_apiUrl));
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}
