import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/modules/add_parts/controllers/add_parts_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  final double _bottomBarHeight = 90;

  AddPartsController controller = Get.find();

  JobDetailsModel job = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Component Fitting"),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15,top: 12),
              child: Text("Extra Parts",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
            ),
            
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
                bottom: 12 + _bottomBarHeight + MediaQuery.of(context).padding.bottom,
              ),
              itemCount: controller.extraItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = controller.extraItems.value[index];
            
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200, width: 0.75),
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
            
                            // const SizedBox(height: 4),
            
                            if (item.size!.isNotEmpty)
                              Text(
                                'Size - ${item.size}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),

                            // const SizedBox(height: 2),
                            Text(
                                'Quantity - ${item.qty}',
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
          ],
        ),
      ),

      /// Bottom Button
      bottomNavigationBar: Obx(
        ()=> SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: InkWell(
              onTap: () async {
                bool resp = await controller.sendApproval(job.id!);
                if(resp){

                }
                else{
                  
                }
              },
              child: CustomButton(
                text: "Ask for Approval",
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
