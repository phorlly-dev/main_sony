import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/utils/Constants.u.dart';

class MenuItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final Widget? desination;
  final IconData? icon;

  const MenuItem({
    super.key,
    required this.label,
    this.isActive = false,
    this.desination,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary.withAlpha(30);
    final activeTextColor = Theme.of(context).colorScheme.primary;
    final borderRadius = BorderRadius.circular(14);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        decoration: BoxDecoration(
          color: isActive ? activeColor : null,
          borderRadius: isActive ? borderRadius : null,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
          ),
          leading: Icon(
            icon ?? Icons.app_registration_rounded,
            color: isActive ? activeTextColor : null,
          ),
          title: Text(
            label,
            style: TextStyle(
              color: isActive ? activeTextColor : null,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: () => Get.to(desination),
          selected: isActive,
          trailing: Icon(
            Icons.arrow_forward_rounded,
            color: isActive ? activeTextColor : null,
          ),
          shape: isActive
              ? RoundedRectangleBorder(borderRadius: borderRadius)
              : null,
        ),
      ),
    );
  }
}
