import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool hasReached = false;

  @override
  Widget build(BuildContext context) {
    JobDetailsModel job = Get.arguments;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double contentWidth = maxWidth > 1000
            ? 900
            : maxWidth > 600
            ? 600
            : maxWidth;

        bool isTablet = maxWidth > 600;
        double switchScale = maxWidth > 600 ? 0.75 : 0.60;
        return Scaffold(
          appBar: CustomAppBar(title: "Navigation"),
          body: Center(
            child: SizedBox(
              width: contentWidth,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 15,
                      vertical: maxWidth * 0.03,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Map Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/mapImage.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: isTablet
                                ? maxWidth * 0.25
                                : maxWidth * 0.75,
                          ),
                        ),

                        SizedBox(height: isTablet ? 28 : 20),

                        /// Status + ETA Row
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Status Update",
                                  style: TextStyle(
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(
                                      102,
                                      112,
                                      133,
                                      1,
                                    ),
                                  ),
                                ),
                                SizedBox(height: isTablet ? 8 : 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   height: isTablet ? 26 : 22,
                                    //   width: isTablet ? 26 : 22,
                                    //   decoration: const BoxDecoration(
                                    //     color: Colors.green,
                                    //     shape: BoxShape.circle,
                                    //   ),
                                    //   child: Icon(
                                    //     Icons.check,
                                    //     color: Colors.white,
                                    //     size: isTablet ? 18 : 16,
                                    //   ),
                                    // ),
                                    Transform.scale(
                                      scale: switchScale,
                                      child: Switch(
                                        value: hasReached,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        inactiveThumbColor: AppColors.blue,
                                        activeThumbColor: Colors.green,
                                        activeTrackColor: Colors.white,
                                        trackColor:
                                            const WidgetStatePropertyAll(
                                              Color.fromRGBO(225, 225, 225, 1),
                                            ),
                                        trackOutlineColor:
                                            const WidgetStatePropertyAll(
                                              Color.fromRGBO(166, 166, 166, 1),
                                            ),
                                        onChanged: (value) {
                                          setState(() {
                                            hasReached = value;
                                          });
                                          if (hasReached) {
                                            Get.toNamed(
                                              AppRoutes.startJobOtp,
                                              arguments: job,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    // const SizedBox(width: 2),
                                    Text(
                                      hasReached ? "Reached" : "On the Way",
                                      style: TextStyle(
                                        fontSize: isTablet ? 18 : 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ETA",
                                  style: TextStyle(
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(
                                      102,
                                      112,
                                      133,
                                      1,
                                    ),
                                  ),
                                ),
                                SizedBox(height: isTablet ? 8 : 6),
                                Text(
                                  "15 mins",
                                  style: TextStyle(
                                    fontSize: isTablet ? 18 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: isTablet ? 25 : 15),

                        /// Customer Information Card
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color.fromRGBO(227, 227, 229, 1),
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isTablet ? 22 : 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Customer Information",
                                  style: TextStyle(
                                    fontSize: isTablet ? 20 : 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                SizedBox(height: isTablet ? 12 : 8),

                                // Row(
                                //   children: [
                                //     Text(
                                //       "Job Details",
                                //       style: TextStyle(
                                //         fontSize: isTablet ? 16 : 14,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //     const Spacer(),
                                //     Text(
                                //       "ID - #${job.id!}",
                                //       style: TextStyle(
                                //         fontSize: isTablet ? 16 : 14,
                                //         color: const Color.fromRGBO(
                                //           102,
                                //           112,
                                //           133,
                                //           1,
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),

                                // SizedBox(height: isTablet ? 14 : 10),

                                Text(
                                  job.customerName!,
                                  style: TextStyle(
                                    fontSize: isTablet ? 19 : 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                SizedBox(height: isTablet ? 6 : 4),

                                Text(
                                  job.location!,
                                  style: TextStyle(
                                    fontSize: isTablet ? 15 : 13,
                                    color: const Color.fromRGBO(
                                      102,
                                      112,
                                      133,
                                      1,
                                    ),
                                  ),
                                ),

                                SizedBox(height: isTablet ? 14 : 10),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: isTablet ? 20 : 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "${job.date}, ",
                                      style: TextStyle(
                                        fontSize: isTablet ? 17 : 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      job.time!,
                                      style: TextStyle(
                                        fontSize: isTablet ? 17 : 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 35 : 25),

                        /// Call Button
                        _buildActionButton(
                          maxWidth: maxWidth,
                          icon: Icons.call_outlined,
                          text: "Call Customer",
                          onPressed: () => {},
                        ),

                        SizedBox(height: isTablet ? 20 : 15),

                        /// Message Button
                        _buildActionButton(
                          maxWidth: maxWidth,
                          icon: Icons.chat_bubble_outline,
                          text: "Message",
                          onPressed: () => {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required double maxWidth,
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    bool isTablet = maxWidth > 600;

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: isTablet ? 65 : 55,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.blue, width: 1),
          color: AppColors.lightBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isTablet ? 26 : 24, color: Colors.black),
            SizedBox(width: isTablet ? 12 : 8),
            Text(
              text,
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
