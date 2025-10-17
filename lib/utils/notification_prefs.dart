import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationPrefs {
  static late SharedPreferences _sp;
  static final _user = OneSignal.User;

  // keys
  static const _kMessages = 'pref_messages';
  static const _kInApp = 'pref_inapp';
  static const _kTogel = 'pref_togel';
  static const _kSlot = 'pref_slot';
  static const _kPush = 'pref_push_enabled';

  // defaults on first install
  static const _dMessages = true;
  static const _dInApp = true;
  static const _dPush = true;
  static const _dTogel = true;
  static const _dSlot = true;

  static Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
  }

  // getters (never null)
  static bool get messages => _sp.getBool(_kMessages) ?? _dMessages;
  static bool get inApp => _sp.getBool(_kInApp) ?? _dInApp;
  static bool get pushOn => _sp.getBool(_kPush) ?? _dPush;
  static bool get togel => _sp.getBool(_kTogel) ?? _dTogel;
  static bool get slot => _sp.getBool(_kSlot) ?? _dSlot;

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
      await OneSignal.Notifications.requestPermission(true);
      await _user.pushSubscription.optIn();
    } else {
      await _user.pushSubscription.optOut();
    }
  }

  static Future<void> setTogel(bool v) async {
    await _sp.setBool(_kTogel, v);

    await toggleTag(_kTogel, v);
  }

  static Future<void> setSlot(bool v) async {
    await _sp.setBool(_kSlot, v);

    await toggleTag(_kSlot, v);
  }

  /// Call this once at startup so the SDK matches stored settings.
  static Future<void> syncToOneSignal() async {
    // await setMessages(messages);
    await setInApp(inApp);
    await setTogel(togel);
    await setSlot(slot);
    await setPushOn(pushOn);
  }

  static Future<void> toggleTag(String key, bool value) async {
    if (value) {
      await _user.addTagWithKey(key, value);
    } else {
      await _user.removeTag(key);
    }
  }
}
