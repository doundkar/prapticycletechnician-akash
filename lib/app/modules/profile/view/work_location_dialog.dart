import 'package:bicycle_app_technician/app/modules/profile/profile_controller.dart';
import 'package:bicycle_app_technician/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:get/get.dart';

class WorkLocationDialog extends StatefulWidget {
  const WorkLocationDialog({super.key});

  @override
  State<WorkLocationDialog> createState() => _WorkLocationDialogState();
}

class _WorkLocationDialogState extends State<WorkLocationDialog> {
  final List<String> addedAreas = [
    "Kharadi",
    "Mundwa",
    "SP Infocity",
    "Keshavnagar",
    "Ghorpadi",
  ];

  final TextEditingController pincodeController = TextEditingController(
    text: "",
  );
  final TextEditingController locationController = TextEditingController(
    text: "",
  );

  ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Obx(() {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 750),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0),
                        child: const Text(
                          "Work Location",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Select the areas where you prefer to work,\nand Add or Remove area as needed.",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  /// Current Location
                  // const Text(
                  //   "Current Location",
                  //   style: TextStyle(fontWeight: FontWeight.w600),
                  // ),

                  // const SizedBox(height: 10),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: const [
                  //     Row(
                  //       children: [
                  //         Icon(Icons.location_on_outlined),
                  //         SizedBox(width: 8),
                  //         Text("Kharadi, Pune"),
                  //       ],
                  //     ),
                  //     Icon(Icons.check),
                  //   ],
                  // ),

                  // const SizedBox(height: 10),

                  /// Added Work Areas
                  const Text(
                    "Added Work Areas",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 10),
                  const Divider(),

                  ...controller.workLocations.map((area) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(area.location!),
                            Row(
                              children: [
                                const Text(
                                  "Remove",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () async {
                                    // setState(() {
                                    //   addedAreas.remove(area);
                                    // });
                                    await controller.deleteWorkLocations(
                                      area.id!,
                                    );
                                  },
                                  child: const Icon(Icons.close, size: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),

                  const SizedBox(height: 12),

                  /// Add Location Button

                  // const SizedBox(height: 20),

                  /// Pincode & Location
                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          label: "Pincode",
                          controller: pincodeController,
                          isPincode: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _textField(
                          label: "Location",
                          controller: locationController,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  InkWell(
                    onTap: () async {
                      if (pincodeController.text.trim().isEmpty ||
                          locationController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackbar.show(
                            title: "Please enter all the details",
                            color: Colors.red[300]!,
                          ),
                        );
                      } else {
                        int pin = int.parse(pincodeController.text.trim());
                        Map<String, dynamic> body = {
                          "location": locationController.text.trim(),
                          "pincode": pin,
                        };
                        await controller.addWorkLocations(body);
                        pincodeController.clear();
                        locationController.clear();
                      }
                    },
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 6,
                              color: Color.fromRGBO(77, 76, 76, 0.1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 15,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline,color: Colors.white,),
                              SizedBox(width: 8),
                              Text("Add Location",style: TextStyle(color: Colors.white),),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                  /// Save Button
                  // InkWell(
                  //   onTap: () async {
                  //     if (pincodeController.text.trim().isEmpty ||
                  //         locationController.text.trim().isEmpty) {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         CustomSnackbar.show(
                  //           title: "Please enter all the details",
                  //           color: Colors.red[300]!,
                  //         ),
                  //       );
                  //     } else {
                  //       int pin = int.parse(pincodeController.text.trim());
                  //       Map<String, dynamic> body = {
                  //         "location": locationController.text.trim(),
                  //         "pincode": pin,
                  //       };
                  //       await controller.addWorkLocations(body);
                  //       pincodeController.clear();
                  //       locationController.clear();
                  //     }
                  //   },
                  //   child: Obx(() {
                  //     if (controller.isLoading.value) {
                  //       return Center(
                  //         child: SizedBox(
                  //           height: 30,
                  //           width: 30,
                  //           child: CircularProgressIndicator(
                  //             strokeWidth: 2,
                  //             color: AppColors.appBg,
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //     return CustomButton(
                  //       text: "Save Changes",
                  //       textSize: 16,
                  //       textWeight: FontWeight.w600,
                  //       textColor: Colors.white,
                  //       bgColor: AppColors.blue,
                  //       radius: 12,
                  //       height: 50,
                  //     );
                  //   }),
                  // ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    bool isPincode = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isPincode ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
