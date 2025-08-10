import 'package:main_sony/views/export_views.dart';

class MenuItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? goTo;
  final IconData? icon;

  const MenuItem({
    super.key,
    required this.label,
    this.isActive = false,
    this.goTo,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColorRole.info.color;
    final activeTextColor = AppColorRole.surface.color;
    final borderRadius = BorderRadius.circular(14);
    final double size = isActive ? 19 : 16;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isActive ? activeColor : null,
          borderRadius: isActive ? borderRadius : null,
        ),
        child: ListTile(
          leading: Icon(
            icon ?? Icons.app_registration_rounded,
            color: isActive ? activeTextColor : null,
            size: size,
          ),
          title: Text(
            label,
            style: TextStyle(
              color: isActive ? activeTextColor : null,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: size / 1.2,
            ),
          ),
          onTap: goTo,
          selected: isActive,
          trailing: Icon(
            Icons.arrow_forward_rounded,
            color: isActive ? activeTextColor : null,
            size: size,
          ),
          shape: isActive
              ? RoundedRectangleBorder(borderRadius: borderRadius)
              : null,
        ),
      ),
    );
  }
}
