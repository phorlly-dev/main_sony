import 'package:main_sony/views/export_views.dart';

class ImageBanner extends StatelessWidget {
  const ImageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: LinkUrl(
        url: "https://bmwgroupusanews.com/",
        builder: (followLink) {
          return InkWell(
            onTap: followLink,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(6)),
              child: Image.asset(
                'assets/images/banner.png',
                width: double.infinity,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
