import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

class IdentityRejectedScreen extends StatelessWidget {
  const IdentityRejectedScreen({super.key});

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
                  child: Image.asset("assets/decline.png",fit: BoxFit.cover,),
                ),

                const SizedBox(height: 24),

                /// Title
                const Text(
                  "Not Verified",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                /// Subtitle
                const Text(
                  "Your documents could not be verified.Please check the reason below and re-upload correct documents.",
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
              
            },
            child: CustomButton(
              text: "Re-upload",
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
