import 'package:flutter/material.dart';
import 'package:main_sony/utils/constants.dart';
import 'package:main_sony/views/widgets/loading_animation.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, color: Colors.red, size: 80),
            const SizedBox(height: 16),
            LoadingAnimation(
              label: 'No Internet Connection',
              type: LoadingType.flickr,
              themColor: AppColorRole.primary,
            ),
          ],
        ),
      ),
    );
  }
}
