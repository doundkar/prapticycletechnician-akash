import 'dart:io';
import 'package:bicycle_app_technician/app/model/component_items_model.dart';
import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/modules/add_parts/controllers/add_parts_controller.dart';
import 'package:bicycle_app_technician/app/modules/job_start/controller/job_progress_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';

class CompleteJobScreen extends StatefulWidget {
  const CompleteJobScreen({super.key});

  @override
  State<CompleteJobScreen> createState() => _CompleteJobScreenState();
}

class _CompleteJobScreenState extends State<CompleteJobScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _photos = [];
  final TextEditingController otpController = TextEditingController();
  late bool showExtra;

  JobProgressController controller = Get.find();
  AddPartsController partsController = Get.find();

  JobDetailsModel job = Get.arguments;

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _photos.add(File(image.path));
      });
    }
  }

  final double _bottomBarHeight = 90;

  @override
  void initState() {
    showExtra = partsController.extraItems.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 9,
            color: Color.fromRGBO(0, 0, 0, 0.05),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange, width: 2),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 9,
            color: Color.fromRGBO(0, 0, 0, 0.05),
          ),
        ],
      ),
    );

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final photoBoxSize = width * 0.22;

    return Scaffold(
      appBar: CustomAppBar(title: "Complete Job"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showExtra) ...[
                Text(
                  "Extra Parts",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  // padding: EdgeInsets.only(
                  //   left: 12,
                  //   right: 12,
                  //   top: 12,
                  //   bottom: 12 + _bottomBarHeight + MediaQuery.of(context).padding.bottom,
                  // ),
                  itemCount: partsController.extraItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    ComponentItemsModel item =
                        partsController.extraItems.value[index];

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// LEFT IMAGE + BUTTON
                          SizedBox(
                            width: 120,
                            height: 136,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                /// Image
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 0.8,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: item.image!.isEmpty
                                          ? Icon(
                                              Icons.image,
                                              size: 120,
                                              color: Colors.grey[300],
                                            )
                                          : Image.network(
                                              item.image!,
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          /// RIGHT SIDE DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  item.title!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                if (item.brand!.isNotEmpty)
                                  Text(
                                    'Brand - ${item.brand}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),

                                const SizedBox(height: 4),

                                if (item.size!.isNotEmpty)
                                  Text(
                                    'Size - ${item.size}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),

                                const SizedBox(height: 10),

                                Text(
                                  '₹${item.price}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlue,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],

              /// After Completion Photos Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "After Completion Photos",
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

                    const SizedBox(height: 15),

                    /// Photos Section
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
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
                              height: 90,
                              width: 90,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                    color: Color.fromRGBO(164, 164, 164, 1),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Add Photo",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(106, 106, 106, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /// Show Selected Photos
                        // ..._photos.map(
                        //   (file) => ClipRRect(
                        //     borderRadius: BorderRadius.circular(12),
                        //     child: Image.file(
                        //       file,
                        //       width: 90,
                        //       height: 90,
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        // ),
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

                    const SizedBox(height: 10),

                    const Text(
                      "*Required: Photos showing completed work",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Service Completed Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.access_time, color: Colors.green, size: 35),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Service Completed",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Review all details before generating the invoice and proceeding to payment.",
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

              const SizedBox(height: 30),

              /// OTP Title
              const Center(
                child: Text(
                  "Enter OTP",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),

              const SizedBox(height: 20),

              /// Pinput OTP
              Center(
                child: Pinput(
                  controller: otpController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      /// Bottom Button
      bottomNavigationBar: Obx(
        () => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: InkWell(
              onTap: () async {
                if (_photos.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackbar.show(
                      title: "Please upload photos",
                      color: Colors.red[300]!,
                    ),
                  );
                } else if (otpController.text.trim().isEmpty ||
                    otpController.text.trim().length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackbar.show(
                      title: "Enter complete OTP",
                      color: Colors.red[300]!,
                    ),
                  );
                } else {
                  int tempOtp = int.parse(otpController.text.trim());
                  final isVerified = await controller.completeJob(
                    job.id!,
                    tempOtp,
                    _photos,
                    [],
                  );

                  if (isVerified) {
                    Get.toNamed(AppRoutes.customerReview, arguments: job);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackbar.show(
                        title: "Wrong or Expired OTP",
                        color: Colors.red[300]!,
                      ),
                    );
                  }
                }
                // Get.toNamed(AppRoutes.customerReview, arguments: job);
              },
              child: CustomButton(
                text: "Complete Job",
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
