import 'dart:async';
import 'dart:developer';

import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/modules/add_parts/controllers/add_parts_controller.dart';
import 'package:bicycle_app_technician/app/modules/auth/controller/sign_up_controller.dart';
import 'package:bicycle_app_technician/app/modules/job_progress/job_progress_screen.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApprovalPendingScreen extends StatefulWidget {
  const ApprovalPendingScreen({super.key});

  @override
  State<ApprovalPendingScreen> createState() => _ApprovalPendingScreenState();
}

class _ApprovalPendingScreenState extends State<ApprovalPendingScreen> {
  Timer? timer;
  int remainingSeconds = 300;
  Timer? approvalTimer;

  AddPartsController controller = Get.find();

  JobDetailsModel job = Get.arguments;

  @override
  void initState() {
    super.initState();
    startTimer();

    ever(controller.approvalStatus, (status) {
      if (status == true) {
        approvalTimer!.cancel();
        Get.to(JobInProgressScreen(isInitial: false,),arguments: job);
      }
    });

    if (controller.approvalStatus.value == false) {
      approvalTimer = Timer.periodic(Duration(seconds: 10), (_) {
        controller.getApprovalStatus(job.id!);
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose(){
    approvalTimer!.cancel();
    super.dispose();
  }

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
                  height: 120,
                  width: 120,
                  child: Image.asset("assets/pending.png", fit: BoxFit.cover),
                ),

                const SizedBox(height: 24),

                // /// Title
                // const Text(
                //   "Approval request sent successfully, Waiting for customer response...",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                // ),

                // const SizedBox(height: 8),

                /// Subtitle
                const Text(
                  "Approval request sent successfully, Waiting for customer response...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
              if (remainingSeconds == 0) {
                //do something
              }
            },
            child: CustomButton(
              text: "Resend",
              textSize: 16,
              textWeight: FontWeight.w600,
              textColor: remainingSeconds == 0 ? Colors.white : Colors.black,
              bgColor: remainingSeconds == 0
                  ? AppColors.blue
                  : Colors.grey[300],
              radius: 12,
              height: 52,
            ),
          ),
        ),
      ),
    );
  }
}
