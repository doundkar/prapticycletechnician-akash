import 'package:bicycle_app_technician/app/modules/job_list/job_list_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';

class AllJobsScreen extends StatefulWidget {
  const AllJobsScreen({super.key});

  @override
  State<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> {
  JobListController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double contentWidth = maxWidth > 1000
            ? 900
            : maxWidth > 600
            ? 600
            : maxWidth;

        bool isTablet = maxWidth > 600;

        return Scaffold(
          appBar: CustomAppBar(title: "All Jobs",isBackNeeded: false,),
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(strokeWidth: 2,color: AppColors.blue,),
                ),
              );
            }
            if (controller.hasError.value) {
              return Center(
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            return Center(
              child: SizedBox(
                width: contentWidth,
                child: SafeArea(
                  child: Column(
                    children: [
                      /// ================= FILTER CHIPS =================
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 16 : 8,
                            vertical: isTablet ? 16 : 12,
                          ),
                          child: Row(
                            children: [
                              _buildFilterChip("All", true, maxWidth),
                              _buildFilterChip("Pending", false, maxWidth),
                              _buildFilterChip("Accepted", false, maxWidth),
                              _buildFilterChip("Completed", false, maxWidth),
                            ],
                          ),
                        ),
                      ),

                      /// ================= JOB LIST =================
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 20 : 6,
                          ),
                          itemCount: controller.newJobRequests.length,
                          itemBuilder: (context, index) {
                            final job = controller.newJobRequests[index];

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: isTablet ? 20 : 10,
                              ),
                              child: _buildJobCard(
                                name: job.customerName!,
                                address: job.location!,
                                serviceTag: "Service",
                                jobTitle: job.jobType!,
                                description: job.description!,
                                duration: job.durationMinutes!,
                                price: job.charges!,
                                status: job.status!,
                                maxWidth: maxWidth, 
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  /// ================= FILTER CHIP =================
  Widget _buildFilterChip(String label, bool isSelected, double maxWidth) {
    bool isTablet = maxWidth > 600;

    return Padding(
      padding: EdgeInsets.only(right: isTablet ? 14 : 10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 16,
          vertical: isTablet ? 12 : 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
          border: Border.all(
            color: Colors.grey.shade400,
            width: isTablet ? 1.2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  /// ================= JOB CARD =================
  Widget _buildJobCard({
    required String name,
    required String address,
    required String serviceTag,
    required String jobTitle,
    String? description,
    required int duration,
    required String price,
    required String status,
    required double maxWidth,
  }) {
    bool isTablet = maxWidth > 600;
    status = status.capitalize!;
    Color statusColor;
    Color statusBg;

    switch (status) {
      case "Pending":
        statusColor = Colors.red;
        statusBg = Colors.red.withOpacity(0.1);
        break;
      case "Accepted":
        statusColor = Colors.blue;
        statusBg = Colors.blue.withOpacity(0.1);
        break;
      case "Completed":
        statusColor = Colors.green;
        statusBg = Colors.green.withOpacity(0.1);
        break;
      default:
        statusColor = Colors.grey;
        statusBg = Colors.grey.withOpacity(0.1);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 8),
      padding: EdgeInsets.all(isTablet ? 22 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border.fromBorderSide(
          BorderSide(color: Color.fromRGBO(227, 227, 229, 1)),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 20,
            offset: Offset(0, 5),
            spreadRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// NAME
          Text(
            name,
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: isTablet ? 6 : 4),

          /// ADDRESS
          Text(
            address,
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: isTablet ? 12 : 8),

          /// SERVICE TAG
          Text(
            serviceTag,
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              color: Colors.blue,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: isTablet ? 12 : 8),

          /// JOB TITLE
          Row(
            children: [
              Expanded(
                child: Text(
                  jobTitle,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          if (description != null) ...[
            SizedBox(height: isTablet ? 6 : 4),
            Text(
              description,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          SizedBox(height: isTablet ? 18 : 12),

          /// DURATION + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: isTablet ? 22 : 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "$duration mins",
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    " - ",
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "₹$price",
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              /// STATUS BADGE
              InkWell(
                onTap: () {
                  if(status == "Pending"){
                    Get.toNamed(AppRoutes.newJobRequest);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 16 : 12,
                    vertical: isTablet ? 8 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: isTablet ? 14 : 13,
                      fontWeight: FontWeight.w400,
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
}
