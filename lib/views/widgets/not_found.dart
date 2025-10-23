import 'package:main_sony/views/export_views.dart';

class NotFound extends StatelessWidget {
  final String title;

  const NotFound({super.key, this.title = 'No Internet Connection!'});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_off, color: Colors.white, size: 60),
        const SizedBox(height: 16),
        LoadingAnimation(
          label: title,
          type: LoadingType.horizontalRotatingDots,
          themeColor: AppColorRole.onPrimary,
          textSize: 14,
        ),
      ],
    );
  }
}
