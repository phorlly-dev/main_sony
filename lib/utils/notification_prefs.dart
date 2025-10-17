import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationPrefs {
  static late SharedPreferences _sp;
  static final _user = OneSignal.User;

  // keys
  static const _kMessages = 'pref_messages';
  static const _kInApp = 'pref_inapp';
  static const _kTopic = 'pref_topic';
  static const _kPush = 'pref_push_enabled';

  // defaults on first install
  static const _dMessages = true;
  static const _dInApp = true;
  static const _dPush = true;
  static const _dTopic = true;

  static Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
  }

  // getters (never null)
  static bool get messages => _sp.getBool(_kMessages) ?? _dMessages;
  static bool get inApp => _sp.getBool(_kInApp) ?? _dInApp;
  static bool get topic => _sp.getBool(_kTopic) ?? _dTopic;
  static bool get pushOn => _sp.getBool(_kPush) ?? _dPush;

  // set + persist + sync with OneSignal
  static Future<void> setMessages(bool v) async {
    await _sp.setBool(_kMessages, v);
    // example: tie messages & mentions together
    if (v) {
      await _user.addTags({_kMessages: v, 'pref_mentions': v});
    } else {
      await _user.removeTags([_kMessages, 'pref_mentions']);
    }
  }

  static Future<void> setInApp(bool v) async {
    await _sp.setBool(_kInApp, v);
    OneSignal.InAppMessages.paused(!v);
  }

  static Future<void> setPushOn(bool v) async {
    await _sp.setBool(_kPush, v);

    if (v) {
      await _user.pushSubscription.optIn();
    } else {
      await _user.pushSubscription.optOut();
    }
  }

  static Future<void> setTopic(bool v) async {
    await _sp.setBool(_kTopic, v);

    // OneSignal v5: single tag "topic" with value togel|slot
    if (v) {
      await _user.removeTag(_kTopic);
      await _user.addTagWithKey(_kTopic, 'slot');
    } else {
      await _user.removeTag(_kTopic);
      await _user.addTagWithKey(_kTopic, 'togel');
    }
  }

  /// Call this once at startup so the SDK matches stored settings.
  static Future<void> syncToOneSignal() async {
    await setMessages(messages);
    await setInApp(inApp);
    await setTopic(topic);
    await setPushOn(pushOn);
  }
}
