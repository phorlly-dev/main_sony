import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/utils/constants.dart';

class NavBar extends StatefulWidget {
  final String title;
  final Widget? menu, content;

  const NavBar({super.key, required this.title, this.menu, this.content});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isDark = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toUpperCase()),
        centerTitle: true,
        elevation: 4,
        backgroundColor: context.getAppColor(AppColorRole.surface),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              Get.changeTheme(isDark ? ThemeData.light() : ThemeData.dark());
              setState(() {
                isDark = !isDark;
              });
            },
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      drawer: widget.menu,
      body: widget.content,
    );
  }
}
