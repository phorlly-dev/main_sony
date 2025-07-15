import 'package:main_sony/views/export_views.dart';

class LinkUrl extends StatelessWidget {
  final String url;
  final LinkTarget target;
  final Widget Function(Future<void> Function()? followLink) builder;

  const LinkUrl({
    super.key,
    required this.url,
    required this.builder,
    this.target = LinkTarget.defaultTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(url),
      target: target,
      builder: (context, followLink) => builder(followLink),
    );
  }
}
