import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/page_controller.dart';
import 'package:main_sony/utils/utility.dart';
import 'package:main_sony/views/widgets/data_render.dart';
import 'package:main_sony/views/widgets/smart_circle_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final PageControllerX controller;

  const ProfileHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DataRender(
      isLoading: controller.isLoading.value,
      hasError: controller.hasError.value,
      notFound: controller.items,
      length: controller.items.length,
      child: (index) {
        return Obx(() {
          final items = controller.items;
          final item = items[index];
          final yoast = item.yoastHeadJson;
          final title = getValue(object: yoast, key: 'title').toString();
          final desc = getValue(object: yoast, key: 'description').toString();
          final ogImage = getValue(object: yoast, key: 'og_image');
          final imgUrl = (ogImage is List && ogImage.isNotEmpty)
              ? ogImage[0]['url']
              : null;

          return UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4db6ac), Color(0xFF43cea2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: SmartCircleAvatar(avatar: imgUrl),
            accountName: Text(title),
            accountEmail: Text(
              substr(key: desc),
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
          );
        });
      },
    );
  }
}
