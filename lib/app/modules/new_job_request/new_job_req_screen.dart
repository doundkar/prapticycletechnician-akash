import 'package:bicycle_app_technician/app/modules/job_list/job_list_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewJobReqScreen extends StatefulWidget {
  const NewJobReqScreen({super.key});

  @override
  State<NewJobReqScreen> createState() => _NewJobReqScreenState();
}

class _NewJobReqScreenState extends State<NewJobReqScreen> {
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
          appBar: CustomAppBar(title: "New Job Request"),
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(strokeWidth: 2),
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
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20 : 12,
                      vertical: isTablet ? 20 : 12,
                    ),
                    itemCount: controller.pendingJobRequests.length,
                    itemBuilder: (context, index) {
                      final job = controller.pendingJobRequests.value[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: isTablet ? 20 : 15),
                        child: _buildJobDetailsCard(
                          maxWidth: maxWidth,
                          jobId: job.id!,
                          name: job.customerName!,
                          address: job.location!,
                          distance: job.distance!,
                          date: job.date!,
                          time: job.time!,
                          duration: job.durationMinutes!,
                          serviceTitle: "Brake Repair",
                          serviceDescription: job.description!,
                          onAccept: () async {
                            await controller.acceptJob(job.id!);
                            Get.back();
                          },
                          onReject: () async {
                            await controller.rejectJob(job.id!);
                            Get.back();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildJobDetailsCard({
    required double maxWidth,
    required int jobId,
    required String name,
    required String address,
    required String distance,
    required String date,
    required String time,
    required int duration,
    required String serviceTitle,
    required String serviceDescription,
    required VoidCallback onAccept,
    required VoidCallback onReject,
  }) {
    bool isTablet = maxWidth > 600;

    return Obx(
      () => Container(
        padding: EdgeInsets.all(isTablet ? 22 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: const Border.fromBorderSide(
            BorderSide(color: Color.fromRGBO(227, 227, 229, 1)),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 15,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Job Details",
                  style: TextStyle(
                    fontSize: isTablet ? 15 : 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "ID - #$jobId",
                  style: TextStyle(
                    fontSize: isTablet ? 15 : 13,
                    color: const Color.fromRGBO(102, 112, 133, 1),
                  ),
                ),
              ],
            ),

            SizedBox(height: isTablet ? 16 : 12),

            /// NAME
            Text(
              name,
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: isTablet ? 6 : 4),

            /// LOCATION
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
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: isTablet ? 14 : 10),

            /// DATE & TIME
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: isTablet ? 20 : 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  "$date, ",
                  style: TextStyle(
                    fontSize: isTablet ? 17 : 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(time, style: TextStyle(fontSize: isTablet ? 17 : 15)),
                const SizedBox(width: 20),
                Icon(
                  Icons.access_time,
                  size: isTablet ? 20 : 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  "$duration mins",
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            SizedBox(height: isTablet ? 20 : 16),

            /// SERVICE BOX
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(249, 250, 251, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceTitle,
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: isTablet ? 6 : 4),
                  Text(
                    serviceDescription,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: const Color.fromRGBO(75, 85, 99, 1),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: isTablet ? 20 : 16),

            /// BUTTONS
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onReject,
                    child: Container(
                      height: isTablet ? 44 : 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(243, 244, 246, 1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color.fromRGBO(96, 96, 96, 1),
                        ),
                      ),
                      child:
                          controller.isLoading.value &&
                              controller.isRejectClicked.value
                          ? Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.blue,
                                ),
                              ),
                            )
                          : Text(
                              "Reject",
                              style: TextStyle(
                                fontSize: isTablet ? 15 : 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(width: isTablet ? 16 : 12),

                Expanded(
                  child: GestureDetector(
                    onTap: onAccept,
                    child: Container(
                      height: isTablet ? 44 : 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          controller.isLoading.value &&
                              controller.isAcceptClicked.value
                          ? Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.appBg,
                                ),
                              ),
                            )
                          : Text(
                              "Accept",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 15 : 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
