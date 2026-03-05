import 'dart:io';
import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/modules/job_start/controller/job_progress_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';

class StartJobScreen extends StatefulWidget {
  const StartJobScreen({super.key});

  @override
  State<StartJobScreen> createState() => _StartJobScreenState();
}

class _StartJobScreenState extends State<StartJobScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _photos = [];

  JobProgressController controller = Get.find();

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _photos.add(File(image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Responsive values
    final horizontalPadding = width * 0.05;
    final photoBoxSize = width * 0.22; // responsive image size
    final iconSize = width * 0.05;
    final bigIconSize = width * 0.08;

    JobDetailsModel job = Get.arguments;

    return Scaffold(
      appBar: CustomAppBar(title: "Start Job"),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(horizontalPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Scheduled
                  Row(
                    children: [
                      Icon(Icons.access_time, size: iconSize),
                      SizedBox(width: width * 0.02),
                      const Text(
                        "Scheduled: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "${job.date}, ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        job.time!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.025),

                  /// Before Starting Card
                  Container(
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.blue),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Before Starting",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "• Take photos of the bicycle’s current condition",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "• Note any existing damage or issues",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "• Verify the service requirements with customer",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.025),

                  /// Before Photos Card
                  Container(
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Before Photos",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${_photos.length} Photos",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.02),

                        Wrap(
                          spacing: width * 0.025,
                          runSpacing: width * 0.025,
                          children: [
                            /// Add Photo Button
                            InkWell(
                              onTap: _openCamera,
                              child: DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  dashPattern: const [6, 3],
                                  radius: const Radius.circular(12),
                                  color: Colors.grey,
                                ),
                                child: Container(
                                  height: photoBoxSize,
                                  width: photoBoxSize,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        size: photoBoxSize * 0.45,
                                        color: const Color.fromRGBO(
                                          164,
                                          164,
                                          164,
                                          1,
                                        ),
                                      ),
                                      SizedBox(height: photoBoxSize * 0.05),
                                      Text(
                                        "Add Photo",
                                        style: TextStyle(
                                          fontSize: photoBoxSize * 0.12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                            106,
                                            106,
                                            106,
                                            1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            /// Show Selected Photos
                            ..._photos.asMap().entries.map((entry) {
                              int index = entry.key;
                              File file = entry.value;

                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      file,
                                      width: photoBoxSize,
                                      height: photoBoxSize,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  /// Cancel Icon
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _photos.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),

                        SizedBox(height: height * 0.015),

                        const Text(
                          "*At least 1 photo is required to start the job",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.025),

                  /// Ready To Start Card
                  Container(
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.green,
                          size: bigIconSize,
                        ),
                        SizedBox(width: width * 0.03),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ready to Start?",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "Timer will begin when you tap “Start Job”",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      /// Bottom Button
      bottomNavigationBar: Obx(
        ()=>SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              24,
            ),
            child: InkWell(
              onTap: () async {
                if(_photos.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackbar.show(title: "Please upload photos", color: Colors.red[300]!));
                }
                else{
                  final resp = await controller.startJob(job.id!, _photos);
                  if(resp){
                    Get.toNamed(AppRoutes.progressJob,arguments: job);
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(CustomSnackbar.show(title: "Couldn't upload photos", color: Colors.red[300]!));
                  }
                }

                // Get.toNamed(AppRoutes.progressJob,arguments: job);
              },
              child: CustomButton(
                text: "Start Job",
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
    );
  }
}
