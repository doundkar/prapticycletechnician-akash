import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

class IdentityApprovedScreen extends StatelessWidget {
  const IdentityApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,

      /// MAIN CONTENT
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// Green Check Icon
                Container(
                  height: 120,
                  width: 120,
                  child: Image.asset("assets/approved.png",fit: BoxFit.cover,),
                ),

                const SizedBox(height: 24),

                /// Title
                const Text(
                  "Congratulations",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                /// Subtitle
                const Text(
                  "Your Identity has been approved.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      /// FIXED BOTTOM BUTTON
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.bottomNav);
            },
            child: CustomButton(
              text: "Complete",
              textSize: 16,
              textWeight: FontWeight.w600,
              textColor: Colors.white,
              bgColor: AppColors.blue,
              radius: 12,
              height: 52,
            ),
          ),
        ),
      ),
    );
  }
}
