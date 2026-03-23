import 'package:bicycle_app_technician/app/modules/profile/profile_controller.dart';
import 'package:bicycle_app_technician/app/modules/profile/view/work_location_dialog.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void showWorkLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const WorkLocationDialog();
      },
    );
  }

  late String name;
  late String image;
  late String userIdStr;
  late String phone;
  late String ratings;
  late String jobsCompleted;
  late int jobs;
  late String tier;

  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  void getDetails() {
    name =
        "${SharedPrefs.getString("first_name")} ${SharedPrefs.getString("last_name")}";
    image = SharedPrefs.getString("image");
    userIdStr = SharedPrefs.getString("user_id");
    phone = SharedPrefs.getString("phone");
    ratings = SharedPrefs.getString("ratings");
    jobsCompleted = SharedPrefs.getString("jobs_completed");
    jobs = int.parse(jobsCompleted);

    if (jobs <= 20) {
      tier = "BRONZE";
    } else if (jobs > 20 && jobs <= 50) {
      tier = "SILVER";
    } else if (jobs > 50 && jobs <= 100) {
      tier = "GOLD";
    } else if (jobs > 100 && jobs <= 200) {
      tier = "DIAMOND";
    } else {
      tier = "PLATINUM";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.04;
    final avatarRadius = screenWidth * 0.10;
    final iconSize = screenWidth * 0.05;

    return Scaffold(
      appBar: CustomAppBar(title: "Profile", isBackNeeded: false),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROFILE CARD
            Container(
              padding: EdgeInsets.all(horizontalPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: Colors.grey,
                        child: image.isEmpty
                            ? Icon(
                                Icons.person,
                                size: avatarRadius,
                                color: Colors.white,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  avatarRadius,
                                ),
                                child: Image.network(
                                  "${ApiConstants.imageBaseUrl}$image",
                                  fit: BoxFit.cover,
                                  height: avatarRadius * 2,
                                  width: avatarRadius * 2,
                                ),
                              ),
                      ),

                      // Positioned(
                      //   bottom: 0,
                      //   right: 0,
                      //   child: Container(
                      //     padding: const EdgeInsets.all(4),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       shape: BoxShape.circle,
                      //       border: Border.all(color: Colors.grey.shade300),
                      //     ),
                      //     child: Icon(Icons.camera_alt,
                      //         size: iconSize * 0.7),
                      //   ),
                      // ),
                    ],
                  ),

                  SizedBox(width: screenWidth * 0.04),

                  /// Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            InkWell(
                              onTap: () async {
                                bool result = await Get.toNamed(
                                  AppRoutes.editProfile,
                                );
                                if (result) {
                                  getDetails();
                                }
                              },
                              child: Icon(Icons.edit, size: iconSize),
                            ),
                          ],
                        ),

                        SizedBox(height: screenWidth * 0.01),

                        Text(phone),

                        SizedBox(height: screenWidth * 0.01),

                        Text(
                          "Technician ID: #TEC$userIdStr",
                          style: const TextStyle(color: Colors.grey),
                        ),

                        SizedBox(height: screenWidth * 0.02),

                        Row(
                          children: [
                            Text(ratings),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text("($jobsCompleted) $tier"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenWidth * 0.05),

            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.referAndEarn);
              },
              child: _profileTile(
                icon: Icons.account_balance_wallet_outlined,
                title: "Refer & Earn",
                subtitle: "0 Active Requests",
                screenWidth: screenWidth,
              ),
            ),

            SizedBox(height: screenWidth * 0.03),

            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.salarySlip);
              },
              child: _profileTile(
                icon: Icons.receipt_long,
                title: "Salary Slip",
                subtitle: "0 Active Requests",
                screenWidth: screenWidth,
              ),
            ),

            SizedBox(height: screenWidth * 0.03),

            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.leaveAttendance);
              },
              child: _profileTile(
                icon: Icons.calendar_today,
                title: "Leaves & Attendance",
                subtitle: "1 Leave this month\nLast week attendance: 6/7 days",
                screenWidth: screenWidth,
              ),
            ),

            SizedBox(height: screenWidth * 0.03),

            InkWell(
              onTap: () {
                showWorkLocationDialog(context);
              },
              child: _profileTile(
                icon: Icons.location_on_outlined,
                title: "Work Location",
                subtitle:
                    "Your Zone : Kharadi, Mundwa, SP Infocity,\nKeshavnagar, Ghorpadi",
                screenWidth: screenWidth,
              ),
            ),

            SizedBox(height: screenWidth * 0.06),

            /// SETTINGS
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.settings, size: iconSize * 1.2),
                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Help & Support"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.toNamed(AppRoutes.helpSupport);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: screenWidth * 0.06),

            /// FOLLOW US
            const Center(
              child: Text(
                "Follow us",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            SizedBox(height: screenWidth * 0.03),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("assets/google.png", height: 30, width: 30),
                  Image.asset("assets/linkedin.png", height: 30, width: 30),
                  Image.asset("assets/x.png", height: 30, width: 30),
                  Image.asset("assets/instagram.png", height: 30, width: 30),
                ],
              ),
            ),

            SizedBox(height: screenWidth * 0.06),

            InkWell(
              onTap: () async {
                await SharedPrefs.setBool("isLoggedIn", false);
                Get.offAllNamed(AppRoutes.signIn);
              },
              child: CustomButton(
                text: "Logout",
                textSize: 16,
                textWeight: FontWeight.w600,
                textColor: Colors.white,
                bgColor: AppColors.blue,
                radius: 12,
                height: 52,
              ),
            ),

            SizedBox(height: screenWidth * 0.05),
          ],
        ),
      ),
    );
  }

  /// Reusable Tile
  Widget _profileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required double screenWidth,
  }) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 10,
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: screenWidth * 0.07),
          SizedBox(width: screenWidth * 0.04),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 4),

                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
