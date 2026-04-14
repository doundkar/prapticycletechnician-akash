import 'package:bicycle_app_technician/app/modules/auth/controller/sign_in_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool agree = false;

  SignInController controller = Get.find();

  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            double contentWidth = maxWidth > 1000
                ? 900
                : maxWidth > 600
                ? 500
                : maxWidth;

            bool isTablet = maxWidth > 600;

            return Center(
              child: SizedBox(
                width: contentWidth,
                child: Obx(
                  () => SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Top Image
                        Image.asset(
                          'assets/technician_img.png',
                          height: isTablet ? maxWidth * 0.55 : maxWidth * 0.9,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),

                        SizedBox(
                          height: isTablet ? maxWidth * 0.12 : maxWidth * 0.25,
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: isTablet ? 32 : 20,
                          ),
                          child: Text(
                            "Log in or Sign up",
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        /// Mobile Number Field
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //     vertical: 15,
                        //     horizontal: isTablet ? 32 : 20,
                        //   ),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       boxShadow: const [
                        //         BoxShadow(
                        //           color: Color.fromRGBO(0, 0, 0, 0.05),
                        //           offset: Offset(0, 2),
                        //           blurRadius: 9,
                        //         ),
                        //       ],
                        //     ),
                        //     child: TextField(
                        //       cursorColor: Colors.black,
                        //       keyboardType: TextInputType.phone,
                        //       controller: phoneController,
                        //       decoration: InputDecoration(
                        //         labelText: "Mobile Number",
                        //         filled: true,
                        //         fillColor: Colors.white,
                        //         labelStyle: TextStyle(
                        //           fontSize: isTablet ? 16 : 14,
                        //           fontWeight: FontWeight.w400,
                        //           color: Colors.black,
                        //         ),
                        //         floatingLabelBehavior:
                        //             FloatingLabelBehavior.always,
                        //         hintText: "",
                        //         prefixText: "+91  |  ",
                        //         prefixStyle: TextStyle(
                        //           fontSize: isTablet ? 18 : 16,
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //         focusedBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(10),
                        //           borderSide: const BorderSide(
                        //             color: Color.fromRGBO(219, 219, 219, 1),
                        //             width: 1,
                        //           ),
                        //         ),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(10),
                        //           borderSide: const BorderSide(
                        //             color: Color.fromRGBO(219, 219, 219, 1),
                        //             width: 1,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        //
                        Padding(
                          padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: isTablet ? 32 : 20,
                              ),
                          child: IntlPhoneField(
                            decoration: InputDecoration(
                              // labelText: 'MOBILE NUMBER',
                              counter: Text(''),
                              labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                            ),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              phoneController.text = phone.number;
                            },
                          ),
                        ),
                         // SizedBox(height: maxWidth * 0.04),

                        /// Login Button
                        GestureDetector(
                          onTap: () async {
                            if (phoneController.text.trim().length != 10 ||
                                phoneController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackbar.show(
                                  title: "Please enter correct number",
                                  color: Colors.red[300]!,
                                ),
                              );
                            } else {
                              await controller.getOtp(
                                phoneController.text.trim(),
                              );
                              if (controller.hasError.value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  CustomSnackbar.show(
                                    title: "This number does not exist",
                                    color: Colors.red[300]!,
                                  ),
                                );
                              } else {
                                String otp = SharedPrefs.getString("otp");
                                // Commented by Akash Doundkar  09-04-2026
                                // ScaffoldMessenger.of(context).showSnackBar(CustomSnackbar.show(title: "OTP : $otp", color: Colors.green[300]!));
                                Get.toNamed(AppRoutes.numbileVerification);
                              }
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 32 : 20,
                            ),
                            child: CustomButton(
                              text: "Login",
                              isLoading: controller.isLoading.value,
                              textSize: isTablet ? 20 : 18,
                              textWeight: FontWeight.w600,
                              textColor: Colors.white,
                              bgColor: const Color.fromRGBO(0, 170, 237, 1),
                              radius: 10,
                              height: isTablet ? 60 : 54,
                              shadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.05),
                                  offset: Offset(0, 2),
                                  blurRadius: 9,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// SignUp Text
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 32 : 20,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.signUp);
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Not a member?  ",
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "SignUp",
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromRGBO(
                                          255,
                                          137,
                                          31,
                                          1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: maxWidth * 0.1),
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
