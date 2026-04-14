import 'package:bicycle_app_technician/app/model/notification_model.dart';
import 'package:bicycle_app_technician/app/modules/notification/notification_controller.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late bool isTablet;
  late bool isSmallPhone;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    isTablet = width >= 768;
    isSmallPhone = width < 360;

    NotificationController controller = Get.find();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",
        onTap: () async {
          await controller.readNotification();
          Get.back();
        },
      ),
      body: Obx(() {
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

        if (controller.hasError.value) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.all(
            isTablet
                ? 24
                : isSmallPhone
                ? 12
                : 16,
          ),
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: isTablet ? 20 : 16),
          itemBuilder: (context, index) {
            NotificationModel item = controller.notifications.value[index];

            return _buildNotificationCard(
              title: item.title!,
              description: item.message!,
              isRead: item.isRead!,
              // actionText: item["actionText"],
              // timeText: item["timeText"],
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.blue,
        onPressed: () async {
          await controller.clearNotification();
        },
        label: Row(
          children: [
            Icon(Icons.cancel, size: 25, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              "Clear Notifications",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String description,
    required bool isRead,
    // String? actionText,
    // String? timeText,
  }) {
    return Container(
      padding: EdgeInsets.all(
        isTablet
            ? 20
            : isSmallPhone
            ? 12
            : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 30,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// TITLE
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: isTablet
                  ? 16
                  : isSmallPhone
                  ? 13
                  : 14,
            ),
          ),

          SizedBox(height: isTablet ? 8 : 6),

          /// DESCRIPTION + isRead
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: isTablet
                        ? 15
                        : isSmallPhone
                        ? 13
                        : 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              if (!isRead) ...[Icon(Icons.circle, size: 10, color: Colors.red)],

              // if (actionText != null)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 8),
              //     child: Text(
              //       actionText,
              //       style: TextStyle(
              //         fontSize: isTablet ? 12 : 10,
              //         color: AppColors.blue,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),

              // if (timeText != null)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 8),
              //     child: Text(
              //       timeText,
              //       style: TextStyle(
              //         fontSize: isTablet ? 12 : 10,
              //         color: const Color.fromRGBO(81, 89, 120, 1),
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    );
  }
}
