import 'package:flutter/material.dart';
import 'package:main_sony/utils/notification_prefs.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  late bool messages, inApp, pushOn, topic;

  @override
  void initState() {
    super.initState();
    messages = NotificationPrefs.messages;
    inApp = NotificationPrefs.inApp;
    pushOn = NotificationPrefs.pushOn;
    topic = NotificationPrefs.topic;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SwitchListTile(
          title: const Text('Messages and mentions'),
          value: messages,
          onChanged: (v) async {
            setState(() => messages = v);
            await NotificationPrefs.setMessages(v);
          },
        ),
        SwitchListTile(
          title: const Text('In-app notifications'),
          value: inApp,
          onChanged: (v) async {
            setState(() => inApp = v);
            await NotificationPrefs.setInApp(v);
          },
        ),
        SwitchListTile(
          title: const Text('Topic Togel | Slot)'),
          value: topic,
          onChanged: (v) async {
            setState(() => topic = v);
            await NotificationPrefs.setTopic(v);
          },
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Enable push notifications'),
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
