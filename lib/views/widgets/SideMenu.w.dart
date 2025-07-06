import 'package:flutter/material.dart';
import 'package:main_sony/controllers/Category.c.dart';
import 'package:main_sony/controllers/Page.c.dart';
import 'package:main_sony/views/partials/Category.p.dart';
import 'package:main_sony/views/partials/ProfileHeader.p.dart';
import 'package:main_sony/views/screens/Home.s.dart';
import 'package:main_sony/views/widgets/MenuItem.w.dart';

class SideMenu extends StatelessWidget {
  final String title;
  final PageControllerX page;
  final CategoryController category;

  const SideMenu({
    super.key,
    required this.title,
    required this.category,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // remove default padding
        children: [
          // Only one header at the top
          ProfileHeader(controller: page),

          MenuItem(
            label: "Home",
            isActive: title == "Home",
            desination: HomeScreen(),
            icon: Icons.home,
          ),

          //Menu item list
          CategoryPartial(controller: category),
        ],
      ),
    );
  }
}
