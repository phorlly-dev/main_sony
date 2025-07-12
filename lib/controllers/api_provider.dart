import 'package:get/get.dart';
import 'package:wordpress_client/wordpress_client.dart';

class ApiProvider extends GetxController {
  final _apiUrl = 'https://soepress.com/wp-json/wp/v2';
  late WordpressClient connx;
  late GetConnect api;
  // var isLoading = false.obs;
  // var totalPages = 1.obs;
  // var isDark = Get.isDarkMode.obs;
  // var hasError = ''.obs;
  // var page = 1.obs;
  // var perPage = 5.obs;
  var selectedItem = "home".obs;

  String get apiUrl => _apiUrl; // optional getter

  void setActiveMenu(String item) {
    selectedItem.value = item;
  }

  @override
  void onInit() {
    super.onInit();
    connx = WordpressClient(baseUrl: Uri.parse(_apiUrl));
    api = GetConnect();
  }

  @override
  void onClose() {
    // Clean up if needed
    connx.clearDiscoveryCache();
    super.onClose();
  }
}
