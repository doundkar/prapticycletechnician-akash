import 'dart:developer';

import 'package:bicycle_app_technician/app/model/service_item_model.dart';
import 'package:bicycle_app_technician/app/modules/job_list/job_list_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobListHomeScreen extends StatefulWidget {
  const JobListHomeScreen({super.key});

  @override
  State<JobListHomeScreen> createState() => _JobListHomeScreenState();
}

class _JobListHomeScreenState extends State<JobListHomeScreen> {
  bool isOnline = SharedPrefs.getBool("is_online");
  String name =
      "${SharedPrefs.getString("first_name")} ${SharedPrefs.getString("last_name")}";
  String image = SharedPrefs.getString("image");
  String userIdStr = SharedPrefs.getString("user_id");

  JobListController controller = Get.find();

  @override
  void initState() {
    super.initState();
    log("""
      User Details
      Is Online: $isOnline
      Name: $name
      Image: $image
      User ID: $userIdStr
      """);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.width > 600 ? 85 : 70,

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                offset: Offset(0, 6),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
        ),

        title: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;

            double avatarRadius = maxWidth > 600 ? 26 : 22;
            double nameFont = maxWidth > 600 ? 18 : 16;
            double idFont = maxWidth > 600 ? 14 : 12;
            double switchScale = maxWidth > 600 ? 0.75 : 0.60;

            return Row(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: Colors.grey[300],
                  child: image.isEmpty
                      ? Icon(Icons.person, size: 40, color: Colors.white)
                      : ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(40),
                          child: Image.network(
                            "${ApiConstants.imageBaseUrl}$image",
                            fit: BoxFit.cover,
                            height: avatarRadius * 2,
                            width: avatarRadius * 2,
                          ),
                        ),
                ),

                SizedBox(width: maxWidth > 600 ? 14 : 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: nameFont,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Technician ID: #$userIdStr",
                        style: TextStyle(
                          fontSize: idFont,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                /// ACTIONS (kept in title to fully control responsiveness)
                Row(
                  children: [
                    Transform.scale(
                      scale: switchScale,
                      child: Switch(
                        value: isOnline,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeThumbColor: Colors.green,
                        activeTrackColor: Colors.white,
                        trackColor: const WidgetStatePropertyAll(
                          Color.fromRGBO(225, 225, 225, 1),
                        ),
                        trackOutlineColor: const WidgetStatePropertyAll(
                          Color.fromRGBO(166, 166, 166, 1),
                        ),
                        onChanged: (value) {
                          _showOnlineModeSheet(value);
                        },
                      ),
                    ),

                    Text(
                      isOnline ? "Online" : "Offline",
                      style: TextStyle(
                        fontSize: maxWidth > 600 ? 16 : 14,
                        fontWeight: FontWeight.w500,
                        color: isOnline ? Colors.green : Colors.grey,
                      ),
                    ),

                    SizedBox(width: maxWidth > 600 ? 16 : 10),

                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.notifications);
                          },
                          child: Icon(
                            Icons.notifications,
                            color: Colors.black,
                            size: maxWidth > 600 ? 26 : 22,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 3,
                          child: Container(
                            height: maxWidth > 600 ? 10 : 8,
                            width: maxWidth > 600 ? 10 : 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: maxWidth > 600 ? 20 : 16),
                  ],
                ),
              ],
            );
          },
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;

          // Max content width for tablet
          double contentWidth = maxWidth > 1000
              ? 900
              : maxWidth > 600
              ? 600
              : maxWidth;

          double horizontalPadding = maxWidth > 600 ? 24 : 15;

          return Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.blue,
                  ),
                ),
              );
            }
            // if (controller.hasError.value) {
            //   return Center(
            //     child: Text(
            //       controller.errorMessage.value,
            //       style: TextStyle(color: Colors.red),
            //     ),
            //   );
            // }
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: contentWidth,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: maxWidth * 0.03,
                      ),
                      child: Column(
                        children: [
                          /// STATUS CARDS
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatusCard(
                                  controller.allJobsCount.value.toString(),
                                  "All Jobs",
                                  Colors.green,
                                  maxWidth,
                                ),
                              ),
                              SizedBox(width: maxWidth * 0.02),
                              Expanded(
                                child: _buildStatusCard(
                                  controller.pendingCount.value.toString(),
                                  "Pending",
                                  Colors.orange,
                                  maxWidth,
                                ),
                              ),
                              SizedBox(width: maxWidth * 0.02),
                              Expanded(
                                child: _buildStatusCard(
                                  controller.completedCount.value.toString(),
                                  "Completed",
                                  Colors.blue,
                                  maxWidth,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: maxWidth * 0.05),

                          if(!isOnline)...[
                            noDataCard(maxWidth: maxWidth, title: "You are offline", subtitle: "Please log in to start receiving jobs!")
                          ],

                          if (isOnline && controller.pendingJobRequests.isEmpty &&
                              controller.acceptedJobRequests.isEmpty) ...[
                            noDataCard(maxWidth: maxWidth,title: "No jobs available yet...",subtitle: "Please wait while admin assigns you new jobs."),
                          ],

                          if (controller.acceptedJobRequests.isNotEmpty) ...[
                            /// ACCEPTED HEADER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Accepted Jobs",
                                  style: TextStyle(
                                    fontSize: maxWidth > 600 ? 18 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${controller.acceptedJobRequests.length}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: maxWidth * 0.03),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.acceptedJobRequests.length,
                              itemBuilder: (BuildContext context, int index) {
                                final job =
                                    controller.acceptedJobRequests.value[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: maxWidth * 0.03,
                                  ),
                                  child: buildAcceptedJobCard(
                                    status: job.status!,
                                    progressStatus: job.status! == "accepted"
                                        ? "In Progress"
                                        : "Completed",
                                    jobId: job.id!,
                                    customerName: job.customerName!,
                                    address: job.location!,
                                    distance: job.distance!,
                                    date: job.date!,
                                    time: job.time!,
                                    duration: job.durationMinutes!,
                                    price: job.charges!,
                                    services: job.serviceItems!,
                                    onNavigate: () {
                                      Get.toNamed(
                                        AppRoutes.navigation,
                                        arguments: job,
                                      );
                                    },
                                    onCall: () {},
                                    maxWidth: maxWidth,
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: maxWidth * 0.05),
                          ],

                          if (controller.pendingJobRequests.isNotEmpty) ...[
                            /// NEW JOB HEADER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "New Job Requests",
                                  style: TextStyle(
                                    fontSize: maxWidth > 600 ? 18 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${controller.pendingJobRequests.length}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: maxWidth * 0.03),

                            /// JOB LIST
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.pendingJobRequests.length,
                              itemBuilder: (context, index) {
                                final job =
                                    controller.pendingJobRequests[index];

                                return Column(
                                  children: [
                                    _buildJobCard(
                                      name: job.customerName!,
                                      location: job.location!,
                                      jobTitle: job.jobType!,
                                      description: job.description!,
                                      time: "${(job.durationMinutes)}",
                                      price: job.charges!,
                                      serviceItems: job.serviceItems!,
                                      maxWidth: maxWidth,
                                    ),
                                    SizedBox(height: maxWidth * 0.03),
                                  ],
                                );
                              },
                            ),
                          ],

                          if (controller.newJobRequests.isEmpty)
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "No jobs are assigned to you yet...",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),

      // bottomNavigationBar: CustomBottomNav(),
    );
  }

  void _showOnlineModeSheet(bool newValue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        double maxWidth = MediaQuery.of(context).size.width;
        bool isTablet = maxWidth > 600;

        return Container(
          width: isTablet ? 600 : double.infinity,
          padding: EdgeInsets.all(isTablet ? 28 : 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Obx(() {
            if (controller.isLoginLoading.value) {
              return SizedBox(
                height: isTablet ? 40 : 30,
                width: double.infinity,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.blue,
                ),
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Online Mode",
                      style: TextStyle(
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, size: isTablet ? 28 : 24),
                    ),
                  ],
                ),

                SizedBox(height: isTablet ? 20 : 16),

                /// DESCRIPTION
                Text(
                  newValue
                      ? "You have logged in online mode for you receive any orders"
                      : "You are going offline. You will not receive new orders.",
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: isTablet ? 28 : 20),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 18 : 14,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          newValue ? "Log Out" : "Cancel",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isTablet ? 16 : 14,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: isTablet ? 16 : 12),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 18 : 14,
                          ),
                        ),
                        onPressed: () async {
                          final resp = await controller.toggleActivity(
                            isOnline,
                          );
                          if (resp) {
                            setState(() {
                              isOnline = newValue;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackbar.show(
                                title: controller.loginMessage.value,
                                color: Colors.green[300]!,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackbar.show(
                                title: controller.loginMessage.value,
                                color: Colors.red[300]!,
                              ),
                            );
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          newValue ? "Log In" : "Go Offline",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 16 : 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isTablet ? 40 : 30),
              ],
            );
          }),
        );
      },
    );
  }
}

/// ================= STATUS CARD METHOD =================
Widget _buildStatusCard(
  String count,
  String label,
  Color color,
  double maxWidth,
) {
  bool isTablet = maxWidth > 600;

  return Container(
    padding: EdgeInsets.symmetric(
      vertical: isTablet ? 20 : 16,
      horizontal: isTablet ? 16 : 12,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.08),
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
      border: Border.all(color: const Color.fromRGBO(229, 231, 235, 1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: isTablet ? 28 : 24,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const Spacer(),

            if (label == "Pending")
              Icon(
                Icons.access_time_filled_outlined,
                color: AppColors.orange,
                size: isTablet ? 26 : 22,
              ),

            if (label == "Completed")
              Container(
                height: isTablet ? 22 : 18,
                width: isTablet ? 22 : 18,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(59, 130, 246, 1),
                ),
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: isTablet ? 16 : 15,
                ),
              ),
          ],
        ),

        SizedBox(height: isTablet ? 6 : 4),

        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}

Widget noDataCard({required double maxWidth,required String title,required String subtitle}) {
  bool isTablet = maxWidth > 600;
  return Container(
    padding: EdgeInsets.all(isTablet ? 20 : 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: isTablet ? 20 : 15,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 18 : 16,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 18 : 16,
          ),
        ),
      ],
    ),
  );
}

/// ================= ACCEPTED JOB CARD METHOD =================
Widget buildAcceptedJobCard({
  required double maxWidth,
  required String status,
  required String progressStatus,
  required int jobId,
  required String customerName,
  required String address,
  required String distance,
  required String date,
  required String time,
  required int duration,
  required String price,
  required List<ServiceItemModel> services,
  VoidCallback? onNavigate,
  VoidCallback? onCall,
}) {
  bool isTablet = maxWidth > 600;
  status = status.capitalize!;

  return Container(
    padding: EdgeInsets.all(isTablet ? 20 : 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: isTablet ? 20 : 15,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Top Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              status,
              style: TextStyle(
                color: const Color(0xFF2F80ED),
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 18 : 16,
              ),
            ),
            Text(
              progressStatus,
              style: TextStyle(
                color: const Color(0xFF2F80ED),
                fontWeight: FontWeight.w400,
                fontSize: isTablet ? 14 : 12,
              ),
            ),
          ],
        ),

        SizedBox(height: isTablet ? 16 : 12),

        /// Job Details + ID
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Job Details",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 16 : 14,
              ),
            ),
            Text(
              "ID - # $jobId",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: isTablet ? 16 : 14,
              ),
            ),
          ],
        ),

        SizedBox(height: isTablet ? 16 : 12),

        /// Customer Name
        Text(
          customerName,
          style: TextStyle(
            fontSize: isTablet ? 22 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: isTablet ? 8 : 6),

        /// Address
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: isTablet ? 20 : 16,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                "$address • $distance kms",
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: isTablet ? 12 : 8),

        /// Date, Time, Duration, Price
        Wrap(
          children: [
            Icon(
              Icons.calendar_today,
              size: isTablet ? 20 : 16,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              "$date, ",
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.access_time,
              size: isTablet ? 20 : 18,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              "$duration mins",
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "₹$price",
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        SizedBox(height: isTablet ? 20 : 16),

        /// Services
        Text(
          "Services Details",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isTablet ? 18 : 16,
          ),
        ),

        SizedBox(height: isTablet ? 12 : 8),

        ...services.asMap().entries.map((entry) {
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

        SizedBox(height: isTablet ? 20 : 16),

        /// Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onNavigate,
                icon: Icon(Icons.navigation, size: isTablet ? 20 : 18),
                label: Text(
                  "Navigate",
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(84, 147, 253, 0.2),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onCall,
                icon: Icon(Icons.call, size: isTablet ? 20 : 18),
                label: Text(
                  "Call",
                  style: TextStyle(fontSize: isTablet ? 16 : 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(84, 147, 253, 0.2),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// ================= JOB CARD METHOD =================
Widget _buildJobCard({
  required String name,
  required String location,
  required String jobTitle,
  required String description,
  required String time,
  required String price,
  required List<ServiceItemModel> serviceItems,
  required double maxWidth,
}) {
  bool isTablet = maxWidth > 600;

  return Container(
    padding: EdgeInsets.all(isTablet ? 18 : 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          blurRadius: 10,
          offset: Offset(0, 0),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Name
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 18 : 16,
          ),
        ),

        SizedBox(height: isTablet ? 6 : 4),

        /// Location
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: isTablet ? 18 : 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                location,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: isTablet ? 14 : 10),

        /// Job Info Box
        Container(
          padding: EdgeInsets.all(isTablet ? 14 : 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(249, 250, 251, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      jobTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: isTablet ? 18 : 16,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: isTablet ? 6 : 4),

              ...serviceItems.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;

                return Text(
                  "${index + 1}. ${item.title}",
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: const Color.fromRGBO(75, 85, 99, 1),
                    fontWeight: FontWeight.w400,
                  ),
                );
              }).toList(),
            ],
          ),
        ),

        SizedBox(height: isTablet ? 10 : 6),

        /// Time + Price
        Row(
          children: [
            Icon(
              Icons.access_time_filled,
              size: isTablet ? 18 : 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              "$time mins",
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "₹$price",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 16 : 14,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
