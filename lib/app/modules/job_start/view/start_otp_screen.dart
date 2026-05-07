import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/modules/job_start/controller/job_progress_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class StartJobOtpScreen extends StatefulWidget {
  const StartJobOtpScreen({super.key});

  @override
  State<StartJobOtpScreen> createState() => _StartJobOtpScreenState();
}

class _StartJobOtpScreenState extends State<StartJobOtpScreen> {
  late TextEditingController otpController;

  JobProgressController controller = Get.find();

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    JobDetailsModel job = Get.arguments;

    return Scaffold(
      appBar: CustomAppBar(title: "Verify OTP"),
      backgroundColor: Colors.white,

      /// ================= BODY =================
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;

          double contentWidth = maxWidth > 1000
              ? 900
              : maxWidth > 600
              ? 600
              : maxWidth;

          bool isTablet = maxWidth > 600;

          final defaultPinTheme = PinTheme(
            width: isTablet ? 70 : 60,
            height: isTablet ? 70 : 60,
            textStyle: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.w600,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 9,
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                ),
              ],
            ),
          );

          final focusedPinTheme = defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange, width: 2),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 9,
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                ),
              ],
            ),
          );

          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: contentWidth,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: isTablet ? 30 : 20),

                        /// Status Update
                        Center(
                          child: Text(
                            "Status Update",
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 14 : 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: isTablet ? 14 : 12,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.check,
                                size: isTablet ? 18 : 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Reached Location",
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: isTablet ? 40 : 30),

                        /// Service Details
                        Text(
                          "Service Details",
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: isTablet ? 20 : 15),

                        // Text(
                        //   "Orders Details",
                        //   style: TextStyle(
                        //     fontSize: isTablet ? 20 : 18,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),

                        // SizedBox(height: isTablet ? 14 : 10),

                        ...job.serviceItems!.asMap().entries.map((entry) {
                          int index = entry.key;
                          var item = entry.value;

                          return Text(
                            "${index + 1}. ${item.title}",
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              color: const Color.fromRGBO(75, 85, 99, 1),
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }).toList(),

                        SizedBox(height: isTablet ? 20 : 15),

                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: isTablet ? 20 : 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${job.durationMinutes} mins - ",
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "₹${job.charges}",
                              style: TextStyle(fontSize: isTablet ? 18 : 16),
                            ),
                          ],
                        ),

                        SizedBox(height: isTablet ? 50 : 40),

                        /// Enter OTP
                        Center(
                          child: Text(
                            "Enter OTP",
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 35 : 25),

                        /// Pinput
                        Center(
                          child: Pinput(
                            controller: otpController,
                            length: 6,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                          ),
                        ),
                         SizedBox(height: isTablet ? 35 : 25),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),

      /// ================= BOTTOM BUTTON =================
      bottomNavigationBar: Obx(() {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: InkWell(
              onTap: () async {
                if (otpController.text.trim().length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackbar.show(
                      title: "Enter complete OTP",
                      color: Colors.red[300]!,
                    ),
                  );
                } else {
                  int tempOtp = int.parse(otpController.text.trim());
                  final isVerified = await controller.verifyStartJobOtp(
                    job.id!,
                    tempOtp,
                  );

                  if (isVerified) {
                    Get.toNamed(AppRoutes.startJob, arguments: job);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackbar.show(
                        title: "Wrong or Expired OTP",
                        color: Colors.red[300]!,
                      ),
                    );
                  }
                  // Get.toNamed(AppRoutes.startJob,arguments: job);
                }
              },
              child: CustomButton(
                text: "Verify",
                isLoading: controller.isLoading.value,
                textSize: 16,
                textWeight: FontWeight.w600,
                textColor: Colors.white,
                bgColor: AppColors.blue,
                radius: 12,
                height: 52,
              ),
            ),
          ),
        );
      }),
    );
  }
}
