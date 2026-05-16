import 'dart:async';

import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/modules/job_start/controller/job_progress_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class JobInProgressScreen extends StatefulWidget {
  bool isInitial;
  JobInProgressScreen({super.key, this.isInitial = true});

  @override
  State<JobInProgressScreen> createState() => _JobInProgressScreenState();
}

class _JobInProgressScreenState extends State<JobInProgressScreen> {
  JobDetailsModel job = Get.arguments;
  bool isPaused = false;

  JobProgressController controller = Get.find();
  int remainingSecondsNext = 60;
  Timer? nextTimer;

  @override
  void initState() {
    super.initState();
    if (widget.isInitial) {
      controller.setRemainingSeconds(job.durationMinutes!);
      controller.setTotalSeconds(job.durationMinutes!);
      controller.startTimer();
    }
    nextTimer = Timer.periodic(Duration(seconds: 1), (nextTimer) {
      if (remainingSecondsNext > 0) {
        setState(() {});
        remainingSecondsNext--;
      } else {
        nextTimer.cancel();
        setState(() {});
      }
    });
  }

  String get formattedTime {
    int hours = controller.remainingSeconds.value ~/ 3600;
    int minutes = (controller.remainingSeconds.value % 3600) ~/ 60;
    int seconds = controller.remainingSeconds.value % 60;

    return "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppBar(title: "Job In Progress", isBackNeeded: false),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// JOB ID Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "JOB ID : #${job.id}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(102, 112, 133, 1),
                      ),
                    ),
                    Text(
                      "Started",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// TIME ELAPSED CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.access_time, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            "TIME ELAPSED",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Obx(
                        () => Text(
                          formattedTime,
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      InkWell(
                        onTap: () {
                          isPaused = !isPaused;
                          if (isPaused) {
                            controller.timer!.cancel();
                          } else {
                            controller.startTimer();
                          }
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPaused ? Icons.play_arrow : Icons.pause,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                isPaused ? "Resume Timer" : "Pause Timer",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// +15 / +30 Buttons
                Row(
                  children: [
                    _timeButton(15),
                    const SizedBox(width: 15),
                    _timeButton(30),
                  ],
                ),

                const SizedBox(height: 30),

                // /// Service Summary
                // const Text(
                //   "Service Job Summary",
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w600,
                //     color: Color.fromRGBO(102, 112, 133, 1),
                //   ),
                // ),

                // const SizedBox(height: 15),

                const Text(
                  "Orders Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 10),

                Text(
                  job.description!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),

                const SizedBox(height: 30),

                /// Need Extra Parts
                const Text(
                  "Need Extra Parts?",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 15),

                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.selectPart, arguments: job);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F2F8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.blue),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text(
                          "Add Parts",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // const Spacer(),
              ],
            ),
          ),
        ),

        /// Bottom Button
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: InkWell(
              onTap: () {
                if (remainingSecondsNext == 0) {
                  controller.calulateTimeTaken();
                  Get.toNamed(AppRoutes.completeJob, arguments: job);
                }
              },
              child: CustomButton(
                text: "Next",
                textSize: 16,
                textWeight: FontWeight.w600,
                textColor:remainingSecondsNext==0 ? Colors.white : Colors.black,
                bgColor: remainingSecondsNext==0 ? AppColors.blue : Colors.grey[300],
                radius: 12,
                height: 52,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Time Add Button
  Widget _timeButton(int time) {
    return InkWell(
      onTap: () {
        int newSeconds = time * 60;
        controller.remainingSeconds.value += newSeconds;
        controller.totalSeconds.value += newSeconds;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: 22),
            const SizedBox(width: 5),
            Text(
              "$time mins",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color.fromRGBO(41, 41, 41, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
