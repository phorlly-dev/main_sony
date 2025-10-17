import 'package:flutter/material.dart';
import 'package:main_sony/utils/notification_prefs.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  late bool messages, inApp, pushOn, togel, slot;

  @override
  void initState() {
    super.initState();
    messages = NotificationPrefs.messages;
    inApp = NotificationPrefs.inApp;
    pushOn = NotificationPrefs.pushOn;
    togel = NotificationPrefs.togel;
    slot = NotificationPrefs.slot;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // SwitchListTile(
        //   title: const Text('Messages & mentions'),
        //   value: messages,
        //   onChanged: (v) async {
        //     setState(() => messages = v);
        //     await NotificationPrefs.setMessages(v);
        //   },
        // ),
        SwitchListTile(
          title: const Text('In-app notifications'),
          value: inApp,
          onChanged: (v) async {
            setState(() => inApp = v);
            await NotificationPrefs.setInApp(v);
          },
        ),
        SwitchListTile(
          title: const Text('Topic related to Slot'),
          value: slot,
          onChanged: (v) async {
            setState(() => slot = v);
            await NotificationPrefs.setSlot(v);
          },
        ),
        SwitchListTile(
          title: const Text('Topic related to Togel'),
          value: togel,
          onChanged: (v) async {
            setState(() => togel = v);
            await NotificationPrefs.setTogel(v);
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
