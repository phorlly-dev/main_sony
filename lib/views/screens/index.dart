import 'package:flutter/material.dart';
import 'package:main_sony/views/screens/home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: HomeScreen(id: 0, type: 0, name: 'Home'));
  }
}
