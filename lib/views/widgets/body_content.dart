import 'package:main_sony/views/export_views.dart';

class BodyContent extends StatelessWidget {
  final Widget? menu, content, button;
  final PreferredSizeWidget? header;

  const BodyContent({
    super.key,
    this.menu,
    this.content,
    this.button,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header,
      drawer: menu == null ? null : SafeArea(child: menu!),
      body: SafeArea(child: content ?? SizedBox.shrink()),
      floatingActionButton: button,
    );
  }
}
