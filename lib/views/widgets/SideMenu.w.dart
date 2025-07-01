import 'package:flutter/material.dart';
import 'package:main_sony/views/partials/Category.p.dart';
import 'package:main_sony/views/partials/ProfileHeader.p.dart';
import 'package:main_sony/views/screens/Home.s.dart';
import 'package:main_sony/views/widgets/MenuItem.w.dart';

class SideMenu extends StatelessWidget {
  final String title;
  const SideMenu({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // remove default padding
        children: [
          // Only one header at the top
          ProfileHeader(),

          MenuItem(
            label: "Home",
            isActive: title == "Home",
            desination: HomeScreen(),
            icon: Icons.home,
          ),

          //Menu item list
          CategoryPartial(),
        ],
      ),
    );
  }
}
