// import 'package:main_sony/config.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/views/export_views.dart';

class IndexScreen extends StatefulWidget {
  // final Params params;
  // const IndexScreen({super.key, required this.params});
  final String name;
  const IndexScreen({super.key, required this.name});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  late PostListController _post;
  late MenuItemController _menuItem;
  late PageControllerX _page;
  late ImageSliderController _imageSlider;

  @override
  void initState() {
    super.initState();
    _post = Get.find<PostListController>();
    _page = Get.find<PageControllerX>();
    _menuItem = Get.find<MenuItemController>();
    _imageSlider = Get.find<ImageSliderController>();
  }

  @override
  Widget build(BuildContext context) {
    return PostsScreen(
      name: widget.name,
      controller: _post,
      page: _page,
      menuItem: _menuItem,
      imageSlider: _imageSlider,
    );
  }
}
