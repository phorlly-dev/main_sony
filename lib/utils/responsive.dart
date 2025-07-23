import 'package:get/get.dart';
import 'package:main_sony/views/export_views.dart';

class Responsive extends StatelessWidget {
  final Widget mobile, tablet;

  const Responsive({super.key, required this.mobile, required this.tablet});

  // This size work fine on my design, maybe you need some customization depends on your design
  static bool isMobile(BuildContext context) =>
      GetPlatform.isMobile || context.isLandscape || context.isPortrait;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If width it less then 900 and more then 650 we consider it as tablet
        if (constraints.maxWidth >= 650 && context.isTablet) {
          return tablet;
        }

        // Or less then that we called it mobile
        return mobile;
      },
    );
  }
}
