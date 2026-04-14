import 'dart:developer';

import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/modules/add_parts/controllers/add_parts_controller.dart';
import 'package:bicycle_app_technician/app/modules/customer_review/customer_review_controller.dart';
import 'package:bicycle_app_technician/app/modules/job_start/controller/job_progress_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:bicycle_app_technician/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class CustomerReviewScreen extends StatefulWidget {
  const CustomerReviewScreen({super.key});

  @override
  State<CustomerReviewScreen> createState() => _CustomerReviewScreenState();
}

class _CustomerReviewScreenState extends State<CustomerReviewScreen> {
  int rating = 0;
  final TextEditingController commentController = TextEditingController();
  CustomerReviewController controller = Get.find();

  JobDetailsModel job = Get.arguments;

  final List<String> options = [
    "Customer was polite",
    "Location was easy to find",
    "Safe working environment",
    "Service instructions were clear",
    "Customer was not reachable",
    "Unsafe working conditions",
    "Customer was rude",
  ];

  final Set<String> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppBar(title: "Customer Review", isBackNeeded: false),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// Title
              const Center(
                child: Text(
                  "Rate your Customer review",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 15),

              /// ⭐ Reactive Stars
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          rating = index + 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.star,
                          size: 36,
                          color: index < rating
                              ? Colors.amber
                              : Colors.grey.shade300,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 30),

              /// Checkbox Options
              ...options.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CheckboxListTile(
                    value: selectedOptions.contains(option),
                    controlAffinity: ListTileControlAffinity.leading,
                    visualDensity: const VisualDensity(vertical: -4),
                    activeColor: AppColors.blue,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedOptions.add(option);
                        } else {
                          selectedOptions.remove(option);
                        }
                        log(selectedOptions.toString());
                      });
                    },
                  ),
                );
              }).toList(),

              const SizedBox(height: 15),

              /// Comments Label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: const Text(
                  "Add additional comments (optional)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),

              const SizedBox(height: 10),

              /// Comments Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color.fromRGBO(176, 176, 176, 1)),
                  ),
                  child: TextField(
                    controller: commentController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),

        /// Bottom Button
        bottomNavigationBar: Obx(
          () => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: InkWell(
                onTap: () async {
                  if (rating == 0 || selectedOptions.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackbar.show(
                        title: "Please rate and select atleast one option",
                        color: Colors.red[300]!,
                      ),
                    );
                  } else {
                    List<String> tags = selectedOptions.toList();

                    Map<String, dynamic> body = {
                      "job_id": job.id!,
                      "rating": rating,
                      "tags": tags,
                      "comment": commentController.text.trim(),
                    };

                    log(body.toString());

                    final resp = await controller.postReview(body);
                    if (resp) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackbar.show(
                          title: "Review submitted successfully",
                          color: Colors.green[300]!,
                        ),
                      );
                      Get.delete<JobProgressController>();
                      Get.delete<AddPartsController>();
                      Get.offAllNamed(AppRoutes.bottomNav);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackbar.show(
                          title: "Review couldn't be submitted",
                          color: Colors.red[300]!,
                        ),
                      );
                    }
                  }
                },
                child: CustomButton(
                  text: "Submit Review",
                  isLoading: controller.isLoading.value,
                  textSize: 16,
                  textWeight: FontWeight.w600,
                  textColor: Colors.white,
                  bgColor: AppColors.blue,
                  radius: 12,
                  height: 52,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
