import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Post.c.dart';
import 'package:main_sony/views/partials/PostedCard.p.dart';
import 'package:main_sony/views/widgets/NavBar.w.dart';
import 'package:main_sony/views/widgets/SideMenu.w.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final ctrl = Get.find<PageControllerX>();
    final ctrl = Get.find<PostController>();

    // final items = ctrl.pages;
    return SafeArea(
      child: NavBar(
        title: "Main Sony",
        menu: SideMenu(title: "Home"),
        content: RefreshIndicator(
          onRefresh: () => ctrl.refreshCurrentPage(),
          child: ListView(
            children: [
              PostedCard(),
              // Obx(() {
              //   return DataView(
              //     itemCounter: items.length,
              //     isLoading: ctrl.isLoading.value,
              //     hasError: ctrl.hasError.value,
              //     notFound: items,
              //     itemBuilder: (context, index) {
              //       final page = items[index];
              //       final yoast = page.yoastHeadJson;
              //       final title = yoast?['title'] ?? 'No Title';
              //       final desc = yoast?['description'] ?? '';
              //       final imgUrl =
              //           (yoast?['og_image'] != null &&
              //               yoast?['og_image'] is List &&
              //               (yoast?['og_image'] as List).isNotEmpty)
              //           ? (yoast?['og_image'] as List)[0]['url']
              //           : null;

              //       return Card(
              //         margin: EdgeInsets.all(12),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         elevation: 2,
              //         child: Padding(
              //           padding: const EdgeInsets.all(16.0),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               if (imgUrl != null)
              //                 ClipRRect(
              //                   borderRadius: BorderRadius.circular(10),
              //                   child: Image.network(
              //                     imgUrl,
              //                     height: 120,
              //                     fit: BoxFit.cover,
              //                   ),
              //                 ),
              //               SizedBox(height: 12),
              //               Text(
              //                 title,
              //                 style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 20,
              //                 ),
              //               ),
              //               SizedBox(height: 8),
              //               Text(
              //                 desc,
              //                 maxLines: 3,
              //                 overflow: TextOverflow.ellipsis,
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //   );
              // }),
            ],
          ),
        ),
      ),
    );
  }
}
