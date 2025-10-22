import 'package:main_sony/views/export_views.dart';
import 'package:main_sony/views/partials/notification_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BodyContent(
      header: NavBar(title: 'App Settings'),
      content: Container(
        margin: const EdgeInsets.only(top: 16),
        child: NotificationSettings(),
      ),
    );
  }
}
