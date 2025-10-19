import 'package:flutter/material.dart';
import 'package:main_sony/utils/notification_prefs.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  late bool pushOn, promo, update;

  @override
  void initState() {
    super.initState();
    pushOn = NotificationPrefs.pushOn;
    promo = NotificationPrefs.promo;
    update = NotificationPrefs.update;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SwitchListTile(
          title: const Text('Promo Notification'),
          value: promo,
          onChanged: (v) async {
            setState(() => promo = v);
            await NotificationPrefs.setPromo(v);
          },
        ),
        SwitchListTile(
          title: const Text('Update Notification'),
          value: update,
          onChanged: (v) async {
            setState(() => update = v);
            await NotificationPrefs.setUpdate(v);
          },
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Enable Push Notification'),
          value: pushOn,
          onChanged: (v) async {
            setState(() => pushOn = v);
            await NotificationPrefs.setPushOn(v);
          },
        ),
      ],
    );
  }
}
