import 'package:get/get.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/views/export_views.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  late final PostListController post;
  late final MenuItemController menuItem;
  late final PageControllerX page;
  late final ScreenParams params;
  late final ImageSliderController imageSlider;

  @override
  void initState() {
    super.initState();

    // Defensive argument parsing with fallback
    params = _getScreenParamsFromArgs(Get.arguments);

    post = Get.find<PostListController>();
    page = Get.find<PageControllerX>();
    menuItem = Get.find<MenuItemController>();
    imageSlider = Get.find<ImageSliderController>();
  }

  /// Safely extract ScreenParams from arguments, or return a default.
  ScreenParams _getScreenParamsFromArgs(dynamic args) {
    if (args is ScreenParams) {
      return args;
    } else if (args is Map) {
      // If navigation sent a Map, parse as best as possible.
      return ScreenParams(name: args['name']);
    }
    // If nothing is passed, return default "home" params.
    return const ScreenParams(name: 'Home');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ViewPostScreen(
        name: params.name,
        controller: post,
        page: page,
        menuItem: menuItem,
        imageSlider: imageSlider,
      ),
    );
  }
}
