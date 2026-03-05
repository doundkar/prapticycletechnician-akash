import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Notifications"),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _buildNotificationCard(
            title: "New Job Assigned",
            description:
                "You have been assigned a new job JOB-1233 for Amit Sharma",
            actionText: "Mark as read",
          ),

          SizedBox(height: 16),

          _buildNotificationCard(
            title: "Job Reminder",
            description:
                "Job-1234 is scheduled to start in 1 hour",
            actionText: "Mark as read",
          ),

          SizedBox(height: 16),

          _buildNotificationCard(
            title: "Customer Review",
            description:
                "Sneha P gave you 5 stars for JOB-12333",
            timeText: "2 hrs",
          ),

          SizedBox(height: 16),

          _buildNotificationCard(
            title: "Payment Received",
            description:
                "1000 has been credited to your wallet for JOB-12345",
            timeText: "2 days ago",
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String description,
    String? actionText,
    String? timeText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: [

          /// TITLE
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 6),

          /// DESCRIPTION + ACTION/TIME
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              if (actionText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    actionText,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              if (timeText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    timeText,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color.fromRGBO(81, 89, 120, 1),
                      fontWeight: FontWeight.w600,
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