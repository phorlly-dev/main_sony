import 'package:main_sony/config.dart';
import 'package:main_sony/views/export_views.dart';

void main() {
  BindingBase.debugZoneErrorsAreFatal = true;

  appConfig();
}


// final raw = json['class_list'];
// List<String>? classes;
// if (raw is List) {
// classes = raw.map((e) => e.toString()).toList();
// } else if (raw is Map) {
// classes = raw.values.map((v) => v.toString()).toList();
// } else if (raw is String) {
// classes = raw.split(' ').where((s) => s.isNotEmpty).toList();
// }
//
// final Map<String, dynamic>? yoastHeadJson;
// final List<String>? classList;