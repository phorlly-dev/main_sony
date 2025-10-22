import 'dart:convert';
import 'package:main_sony/utils/export_util.dart';
import 'package:main_sony/views/master.dart';
import 'package:wordpress_client/wordpress_client.dart';

class CustomCodec extends Codec<Object?, Object?> {
  @override
  Converter<Object?, Object?> get decoder => _CustomDecoder();

  @override
  Converter<Object?, Object?> get encoder => _CustomEncoder();
}

class _CustomEncoder extends Converter<Object?, Object?> {
  @override
  Object? convert(input) {
    if (input == null) return null;

    if (input is Post) {
      return input.toJson();
    }

    return input;
  }
}

class _CustomDecoder extends Converter<Object?, Object?> {
  @override
  Object? convert(input) {
    if (input == null) return null;

    if (input is Map<String, dynamic> &&
        input.containsKey('type') &&
        input['type'] == 'Post') {
      return Post.fromJson(input);
    }

    return input;
  }
}

class AnalyticsObserver extends NavigatorObserver {
  @override
  void didPush(route, previousRoute) async {
    await analytics.setAnalyticsCollectionEnabled(true);
    await analytics.logScreenView(
      screenName: route.settings.name,
      screenClass: previousRoute?.settings.name,
    );
  }
}
