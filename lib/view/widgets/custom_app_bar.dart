import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  String? title;
  IconData? icon;
  bool isBackNeeded;

  CustomAppBar({
    super.key,
    required this.title,
    this.isBackNeeded = true,
    this.icon = Icons.arrow_back_ios,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "${widget.title}",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.blue,
      leading: widget.isBackNeeded
          ? IconButton(
              icon: Icon(widget.icon, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            )
          : SizedBox.shrink(),
    );
  }
}
