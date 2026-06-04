import 'dart:async';
import 'dart:io';
import 'package:bicycle_app_technician/app/modules/auth/controller/sign_in_controller.dart';
import 'package:bicycle_app_technician/app/modules/profile/profile_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class NumberUpdateVerificationScreen extends StatefulWidget {
  const NumberUpdateVerificationScreen({super.key});

  @override
  State<NumberUpdateVerificationScreen> createState() =>
      _NumberUpdateVerificationScreenState();
}

class _NumberUpdateVerificationScreenState
    extends State<NumberUpdateVerificationScreen> {
  Timer? timer;
  int remainingSeconds = 60;

  ///
  TextEditingController otpController = TextEditingController();

  ProfileController controller = Get.find();

  @override
  void initState() {
    super.initState();
    startTimer();
    // String otp = SharedPrefs.getString("otp");

    // if (otp.isNotEmpty) {
    //   otpController.text = otp;
    // }
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
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    String phone = args["phone"] ?? "";
    String email = args["email"] ?? "";
    String image = args["image"] ?? "";

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            double contentWidth = maxWidth > 600 ? 500 : maxWidth;

            // Responsive OTP size
            double otpWidth = maxWidth > 400 ? 55 : 45;
            double otpHeight = maxWidth > 400 ? 60 : 50;

            return Obx(
              () => Center(
                child: SizedBox(
                  width: contentWidth,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: maxWidth * 0.08),

                        /// Title
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Enter Verification Code",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        SizedBox(height: maxWidth * 0.05),

                        const Text(
                          "We've sent the verification code on",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "+91 $phone",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.edit, size: 14),
                            ),
                          ],
                        ),

                        const Text(
                          "via SMS",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: maxWidth * 0.08),

                        /// OTP PIN INPUT (Responsive)
                        Pinput(
                          length: 6,
                          controller: otpController,
                          defaultPinTheme: PinTheme(
                            width: otpWidth,
                            height: otpHeight,
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color.fromRGBO(229, 231, 235, 1),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 6,
                                  color: Color.fromRGBO(0, 0, 0, 0.05),
                                ),
                              ],
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: otpWidth,
                            height: otpHeight,
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.orange,
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: maxWidth * 0.06),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn't receive the code?",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 5),

                            InkWell(
                              onTap: () async {
                                if (remainingSeconds == 0) {
                                  bool resp = await controller.updateProfileReq(
                                    phone,
                                    email: email,
                                    image: image.isNotEmpty
                                        ? File(image)
                                        : null,
                                  );

                                  if (resp) {
                                    // String otp = SharedPrefs.getString("otp");

                                    setState(() {
                                      // otpController.text =
                                      //     otp; // autofill new otp
                                      remainingSeconds = 60;

                                      ///
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CustomSnackbar.show(
                                        title: "OTP sent on WhatsApp Number",
                                        color: Colors.green[300]!,
                                      ),
                                    );
                                    timer?.cancel();
                                    startTimer();
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: remainingSeconds == 0
                                      ? Colors.black
                                      : Colors.grey[300],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    "Resend",
                                    style: TextStyle(
                                      color: remainingSeconds == 0
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: maxWidth * 0.06),

                        /// Submit Button
                        InkWell(
                          onTap: () async {
                            if (otpController.text.trim().isEmpty ||
                                otpController.text.trim().length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackbar.show(
                                  title: "Please enter complete OTP",
                                  color: Colors.red[300]!,
                                ),
                              );
                            } else {
                              final resp = await controller.verifyUpdateProfile(
                                otpController.text.trim(),
                              );
                              if (resp) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackbar.show(
                                    title: "Profile updated successfully",
                                    color: Colors.green[300]!,
                                  ),
                                );
                                Get.toNamed(AppRoutes.bottomNav);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackbar.show(
                                    title: "Profile couldn't be updated",
                                    color: Colors.red[300]!,
                                  ),
                                );
                              }
                            }
                          },
                          child: CustomButton(
                            text: "Submit",
                            isLoading: controller.isLoading.value,
                            textSize: 18,
                            textWeight: FontWeight.w600,
                            textColor: Colors.white,
                            bgColor: const Color.fromRGBO(0, 170, 237, 1),
                            radius: 10,
                            height: 50,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Timer
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Resend in  ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "$remainingSeconds s",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(255, 137, 31, 1),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: maxWidth * 0.08),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
