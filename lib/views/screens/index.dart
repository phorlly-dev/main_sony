import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/views/export_views.dart';

class IndexScreen extends StatefulWidget {
  final ScreenParams? params;
  const IndexScreen({super.key, required this.params});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  late PostListController post;
  late MenuItemController menuItem;
  late PageControllerX page;
  late ImageSliderController imageSlider;

  @override
  void initState() {
    super.initState();
    post = Get.find<PostListController>();
    page = Get.find<PageControllerX>();
    menuItem = Get.find<MenuItemController>();
    imageSlider = Get.find<ImageSliderController>();
  }

  @override
  Widget build(BuildContext context) {
    final params = widget.params;
    return ViewPostScreen(
      name: params?.name ?? "Home",
      controller: post,
      page: page,
      menuItem: menuItem,
      imageSlider: imageSlider,
    );
  }
}
