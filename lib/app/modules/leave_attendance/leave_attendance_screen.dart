import 'dart:developer';

import 'package:bicycle_app_technician/app/modules/leave_attendance/leave_controller.dart';
import 'package:bicycle_app_technician/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class LeavesAttendanceScreen extends StatefulWidget {
  const LeavesAttendanceScreen({super.key});

  @override
  State<LeavesAttendanceScreen> createState() => _LeavesAttendanceScreenState();
}

class _LeavesAttendanceScreenState extends State<LeavesAttendanceScreen> {
  LeaveController controller = Get.find();

  late DateTime focusDay;

  final Set<DateTime> leaveDays = {DateTime(2025, 9, 23)};

  final TextEditingController reasonController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    focusDay = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final padding = width * 0.04;
    final spacingSmall = height * 0.012;
    final spacingMedium = height * 0.02;
    final spacingLarge = height * 0.03;

    final calendarCircle = width * 0.08;

    return Scaffold(
      appBar: CustomAppBar(title: "Leaves & Attendance"),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: SizedBox(
              height: width * 0.08,
              width: width * 0.08,
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
              style: const TextStyle(fontSize: 26, color: Colors.red),
            ),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// CALENDAR CARD
                Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    border: Border.all(
                      color: const Color.fromRGBO(232, 232, 232, 1),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    if (controller.isReportLoading.value) {
                      return SizedBox(
                        height: height * 0.35,
                        width: double.infinity,
                        child: Center(
                          child: SizedBox(
                            height: width * 0.08,
                            width: width * 0.08,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      );
                    }
                    return TableCalendar(
                      firstDay: DateTime(2020),
                      lastDay: DateTime(2030),
                      focusedDay: focusDay,

                      onPageChanged: (focusedDay) async {
                        focusDay = focusedDay;
                        await controller.getReport(
                          focusedDay.year,
                          focusedDay.month,
                        );
                        await controller.getLeaves(
                          focusedDay.year,
                          focusDay.month,
                        );
                      },

                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),

                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),

                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, _) {
                          if (_isSameDay(day, controller.absentDays.value)) {
                            return _buildCircleDay(
                              day.day,
                              Colors.red,
                              calendarCircle,
                            );
                          } else if (_isSameDay(
                            day,
                            controller.presentDays.value,
                          )) {
                            return _buildCircleDay(
                              day.day,
                              Colors.green,
                              calendarCircle,
                            );
                          } else if (_isSameDay(
                            day,
                            controller.setLeaves.value,
                          )) {
                            return _buildCircleDay(
                              day.day,
                              Colors.amber[300]!,
                              calendarCircle,
                            );
                          } else if (_isSameDay(
                            day,
                            controller.weekOffDays.value,
                          )) {
                            return _buildCircleDay(
                              day.day,
                              Colors.amber[300]!,
                              calendarCircle,
                            );
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                ),

                SizedBox(height: spacingMedium),

                /// ABSENT CARD
                Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(251, 251, 251, 1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color.fromRGBO(221, 221, 221, 1),
                    ),
                  ),
                  child: Obx(() {
                    if (controller.isReportLoading.value) {
                      return SizedBox(
                        height: height * 0.05,
                        width: double.infinity,
                        child: Center(
                          child: SizedBox(
                            height: width * 0.08,
                            width: width * 0.08,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Absent",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Icon(Icons.expand_more),
                          ],
                        ),
                        SizedBox(height: spacingSmall),
                        Text(
                          "${controller.leaves.length} day(s) in (${DateFormat("MMM").format(focusDay)},${focusDay.year})",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Divider(),
                        ...controller.leaves.map((l) {
                          return Text(
                            DateFormat(
                              'EEE, d MMM yyyy',
                            ).format(DateTime.parse(l.startDate!)),
                          );
                        }),
                      ],
                    );
                  }),
                ),

                SizedBox(height: spacingLarge),

                /// LEAVE APPLICATION TITLE
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Leave Application",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Icon(Icons.add_circle_outline, color: Colors.blue),
                  ],
                ),

                SizedBox(height: spacingSmall),

                /// LEAVE FORM
                Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(251, 251, 251, 1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color.fromRGBO(221, 221, 221, 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Reason",
                        style: TextStyle(color: Colors.grey),
                      ),

                      SizedBox(height: spacingSmall),

                      TextField(
                        controller: reasonController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      SizedBox(height: spacingMedium),

                      Row(
                        children: [
                          Expanded(
                            child: _dateField(
                              "Start Date",
                              startDate != null
                                  ? _formatDate(startDate!)
                                  : "Select Date",
                              padding,
                              onTap: _pickStartDate,
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: _dateField(
                              "End Date",
                              endDate != null
                                  ? _formatDate(endDate!)
                                  : "Select Date",
                              padding,
                              onTap: _pickEndDate,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: spacingLarge),

                /// APPLY BUTTON
                InkWell(
                  onTap: () async {
                    if (reasonController.text.trim().isEmpty ||
                        startDate == null ||
                        endDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackbar.show(
                          title: "Please add all the details",
                          color: Colors.red[300]!,
                        ),
                      );
                    } else {
                      final body = {
                        "start_date": DateFormat(
                          'yyyy-MM-dd',
                        ).format(startDate!),
                        "end_date": DateFormat('yyyy-MM-dd').format(endDate!),
                        "type": "unpaid",
                        "reason": reasonController.text.trim(),
                      };
                      bool resp = await controller.applyLeave(body);
                      if (resp) {
                        reasonController.clear();
                        startDate = null;
                        endDate = null;
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackbar.show(
                            title: "Leave Application submitted successfully",
                            color: Colors.green[300]!,
                          ),
                        );
                        setState(() {});
                      }
                    }
                  },
                  child: CustomButton(
                    text: "Apply for Leave",
                    isLoading: controller.isApplyLeaveLoading.value,
                    textSize: 16,
                    textWeight: FontWeight.w600,
                    textColor: Colors.white,
                    bgColor: AppColors.blue,
                    radius: 12,
                    height: 52,
                  ),
                ),

                SizedBox(height: spacingLarge),
              ],
            ),
          ),
        );
      }),
    );
  }

  bool _isSameDay(DateTime day, Set<DateTime> days) {
    return days.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
  }

  Widget _buildCircleDay(int day, Color color, double size) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _dateField(
    String label,
    String value,
    double padding, {
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: padding * 0.9,
              horizontal: padding * 0.8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100,
            ),
            child: Text(value),
          ),
        ),
      ],
    );
  }

  Future<void> _pickStartDate() async {
    DateTime today = DateTime.now();

    DateTime firstSelectableDate = today.add(const Duration(days: 2));

    final picked = await showDatePicker(
      context: context,
      initialDate: firstSelectableDate,
      firstDate: firstSelectableDate,
      lastDate: DateTime(today.year + 2),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;

        if (endDate != null && endDate!.isBefore(startDate!)) {
          endDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    if (startDate == null) {
      Get.snackbar("Select Start Date", "Please select start date first");
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: startDate!,
      firstDate: startDate!,
      lastDate: DateTime(startDate!.year + 2),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${_monthName(date.month)} ${date.day}, ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }
}
