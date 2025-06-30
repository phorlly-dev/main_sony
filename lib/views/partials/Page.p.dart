import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Page.c.dart';
import 'package:main_sony/views/widgets/DataView.w.dart';

class PagePartial extends StatelessWidget {
  const PagePartial({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PageControllerX>();

    return DataView(
      isLoading: ctrl.isLoading.value,
      hasError: ctrl.hasError.value,
      notFound: ctrl.pages,
      itemCounter: ctrl.pages.length,
      itemBuilder: (context, index) {
        final item = ctrl.pages[index];
        //  final yoast = item.yoastHeadJson;
        //   String title = yoast?.title ?? 'Main Sony';
        //   String description = yoast?.description ?? 'Main Sony Description';
        //       // String imageUrl = (yoast?.ogImage?.isNotEmpty ?? false)
        //       //     ? (yoast?.ogImage?.first.url ?? '')
        //       //     : '';
        return DrawerHeader(
          decoration: BoxDecoration(color: Colors.teal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SmartCircleAvatar(avatar: imageUrl),
              ListTile(
                title: Text(
                  item.title?.rendered ?? 'Main Sony',
                  style: TextStyle(color: Colors.white),
                ),
                // subtitle: Text(
                //   substr(key: item.),
                //   style: TextStyle(fontSize: 12, color: Colors.white70),
                // ),
              ),
            ],
          ),
        );
      },
    );

    // return Obx(() {
    //   if (ctrl.pages.isEmpty) {
    //     return const Center(child: CircularProgressIndicator());
    //   }
    //   return Column(
    //     children: ctrl.pages.map((items) {
    //       final yoast = items.yoastHeadJson;
    //       String title = yoast?.title ?? 'Main Sony';
    //       String description = yoast?.description ?? 'Main Sony Description';
    //       // String imageUrl = (yoast?.ogImage?.isNotEmpty ?? false)
    //       //     ? (yoast?.ogImage?.first.url ?? '')
    //       //     : '';
    //       return DrawerHeader(
    //         decoration: BoxDecoration(color: Colors.teal),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             // SmartCircleAvatar(avatar: imageUrl),
    //             ListTile(
    //               title: Text(title, style: TextStyle(color: Colors.white)),
    //               subtitle: Text(
    //                 substr(key: description),
    //                 style: TextStyle(fontSize: 12, color: Colors.white70),
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     }).toList(),
    //   );
    // });
  }
}
