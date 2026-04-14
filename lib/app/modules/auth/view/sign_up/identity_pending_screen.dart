import 'dart:async';
import 'dart:developer';

import 'package:bicycle_app_technician/app/modules/auth/controller/sign_up_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class IdentityPendingScreen extends StatefulWidget {
  const IdentityPendingScreen({super.key});

  @override
  State<IdentityPendingScreen> createState() => _IdentityPendingScreenState();
}

class _IdentityPendingScreenState extends State<IdentityPendingScreen> {
  late final SignUpController controller;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SignUpController>();
    timer = Timer.periodic(Duration(seconds: 5), (timer){
      controller.getOtp();
    });
    ever(controller.isVerified, (value) async {
      log("called ever");
      if (value == true) {
        timer!.cancel();
        await controller.checkVerification();
        Get.offAllNamed(AppRoutes.identityApproved);
      }
      // else{
      //   timer!.cancel();
      //   Get.snackbar("Error", "Technician is not verified yet.",backgroundColor: Colors.red);
      //   Get.back(result: 'Data from this page');
      //
      // }
    });
  }

  // void checkIfVerified() {
  //   if (controller.isVerified.value) {
  //     log("isVerified:${controller.isVerified.value}");
  //     Get.toNamed(AppRoutes.identityApproved);
  //   }
  // }

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
                /// Pending Image
                SizedBox(
                  height: 140,
                  width: 140,
                  //child: Image.asset("assets/pending.png", fit: BoxFit.cover),
                  child: Lottie.asset("assets/loading_gray.json",repeat: true),
                ),

                const SizedBox(height: 24),

                /// Title
                const Text(
                  "Verification is still pending",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                /// Subtitle
                const Text(
                  "Our admin team is reviewing your Document details.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),

      /// FIXED BOTTOM BUTTON
      // bottomNavigationBar: SafeArea(
      //   child: Padding(
      //     padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      //     child: InkWell(
      //       onTap: () {
      //         Get.toNamed(AppRoutes.uploadDocuments);
      //       },
      //       child: CustomButton(
      //         text: "Re-upload",
      //         textSize: 16,
      //         textWeight: FontWeight.w600,
      //         textColor: Colors.white,
      //         bgColor: AppColors.blue,
      //         radius: 12,
      //         height: 52,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
