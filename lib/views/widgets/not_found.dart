import '../export_views.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_off, color: Colors.white, size: 60),
        const SizedBox(height: 16),
        LoadingAnimation(
          label: 'No Internet Connection!',
          type: LoadingType.horizontalRotatingDots,
          themColor: AppColorRole.onPrimary,
          textSize: 14,
        ),
      ],
    );
  }
}
