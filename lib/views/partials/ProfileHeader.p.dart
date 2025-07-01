import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/Page.c.dart';
import 'package:main_sony/utils/Utility.u.dart';
import 'package:main_sony/views/widgets/DataRender.w.dart';
import 'package:main_sony/views/widgets/SmartCircleAvatar.w.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PageControllerX>();

    return DataRender(
      isLoading: ctrl.isLoading.value,
      hasError: ctrl.hasError.value,
      notFound: ctrl.pages,
      length: ctrl.pages.length,
      child: (index) {
        return Obx(() {
          final items = ctrl.pages;
          final item = items[index];
          final yoast = item.yoastHeadJson;
          final title = yoast?['title'] ?? 'Main Sony Serba Dunia Game';
          final desc =
              yoast?['description'] ??
              'Main Sony adalah portal game seru untuk Android';
          final imgUrl =
              (yoast?['og_image'] != null &&
                  yoast?['og_image'] is List &&
                  (yoast?['og_image'] as List).isNotEmpty)
              ? (yoast?['og_image'] as List)[0]['url']
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
