import 'dart:developer';
import 'dart:io';
import 'package:bicycle_app_technician/app/modules/auth/controller/sign_up_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/widgets/custom_snackbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final ImagePicker _picker = ImagePicker();

  File? aadharFront;
  File? aadharBack;
  File? panCard;

  Future<void> pickImage(Function(File) onImageSelected) async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      onImageSelected(File(image.path));
    }
  }

  final SignUpController controller = Get.find();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            double contentWidth = maxWidth > 600 ? 500 : maxWidth;

            return Obx(
              ()=> Center(
                child: SizedBox(
                  width: contentWidth,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
              
                        Text(
                          "Verification",
                          style: TextStyle(
                              fontSize: maxWidth * 0.06,
                              fontWeight: FontWeight.w800),
                        ),
              
                        SizedBox(height: maxWidth * 0.05),
              
                        /// ================= AADHAR CONTAINER =================
                        _buildDocumentSection(
                          title: "Aadhar Front",
                          file: aadharFront,
                          onUpload: () => pickImage((file) {
                            setState(() => aadharFront = file);
                          }),
                          onRemove: () {
                            setState(() => aadharFront = null);
                          },
                        ),
              
                        SizedBox(height: maxWidth * 0.05),
              
                        _buildDocumentSection(
                          title: "Aadhar Back",
                          file: aadharBack,
                          onUpload: () => pickImage((file) {
                            setState(() => aadharBack = file);
                          }),
                          onRemove: () {
                            setState(() => aadharBack = null);
                          },
                        ),
              
                        SizedBox(height: maxWidth * 0.05),
              
                        /// ================= PAN =================
                        _buildDocumentSection(
                          title: "Pan Card",
                          file: panCard,
                          onUpload: () => pickImage((file) {
                            setState(() => panCard = file);
                          }),
                          onRemove: () {
                            setState(() => panCard = null);
                          },
                        ),
              
                        SizedBox(height: maxWidth * 0.06),
              
                        InkWell(
                          onTap: () async {
                            if(aadharFront!.path.isEmpty || aadharBack!.path.isEmpty || panCard!.path.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(CustomSnackbar.show(title: "Please upload all documents", color: Colors.red[300]!));
                            }
                            else{
                              await controller.verifyDocuments(aadharBack: aadharFront,aadharFront: aadharBack,pancard: panCard);
                              if(controller.isStep2Completed.value){
                                Get.toNamed(AppRoutes.identityPending);
                              }
                              log(controller.errorMessage.value);
                            }
                          },
                          child: CustomButton(
                            text: "Verify",
                            isLoading: controller.isLoading.value,
                            textSize: 18,
                            textWeight: FontWeight.w600,
                            textColor: Colors.white,
                            bgColor: AppColors.blue,
                            radius: 10,
                            height: 50,
                          ),
                        ),
              
                        SizedBox(height: maxWidth * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// ================= DOCUMENT SECTION =================
  Widget _buildDocumentSection({
    required String title,
    required File? file,
    required VoidCallback onUpload,
    required VoidCallback onRemove,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color.fromRGBO(50, 128, 176, 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const Text("Only support jpg, png",
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),

            const SizedBox(height: 20),

            /// Upload Box
            GestureDetector(
              onTap: onUpload,
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: const Radius.circular(10),
                  color: const Color.fromRGBO(0, 170, 237, 1),
                  strokeWidth: 1.5,
                  dashPattern: const [6, 4],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Icon(Icons.upload_file, size: 42),
                        const SizedBox(height: 10),
                        Text("Upload $title Image"),
                        const SizedBox(height: 10),
                        Container(
                          width: 113,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                const Color.fromRGBO(0, 170, 237, 0.2),
                            border: Border.all(
                              color: AppColors.blue,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 8),
                          child: const Text("Upload",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Preview Selected Image
            if (file != null)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromRGBO(231, 231, 231, 1),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Image.file(file,
                        height: 36, width: 36, fit: BoxFit.cover),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        file.path.split('/').last,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(Icons.cancel_outlined,
                          size: 25,
                          color: Color.fromRGBO(114, 119, 122, 1)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}