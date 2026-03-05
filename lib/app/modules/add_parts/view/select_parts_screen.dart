import 'package:bicycle_app_technician/app/model/components_model.dart';
import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/modules/add_parts/controllers/add_parts_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/view/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:get/get.dart';

class SelectPartsScreen extends StatefulWidget {
  const SelectPartsScreen({super.key});

  @override
  State<SelectPartsScreen> createState() => _SelectPartsScreenState();
}

class _SelectPartsScreenState extends State<SelectPartsScreen> {
  int selectedIndex = -1;
  int categoryId = -1;

  AddPartsController controller = Get.find();
  JobDetailsModel job = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Responsive values
    final horizontalPadding = width * 0.04;
    final gridSpacing = width * 0.03;
    final iconSize = width * 0.18; // responsive icon size
    final textSize = width * 0.032;
    final topSpacing = height * 0.02;

    return Scaffold(
      appBar: CustomAppBar(title: "Select Parts"),

      body: Obx(() {
        if(controller.isLoading.value){
          return Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(strokeWidth: 3,color: AppColors.blue,),
            ),
          );
        }
        if(controller.hasError.value){
          return Center(
            child: Column(
              children: [
                Icon(Icons.error_outline,color: Colors.grey,size: 30,),
                const SizedBox(height: 10,),
                Text(controller.errorMessage.value,style: TextStyle(fontSize: 18,color: Colors.red),)
              ],
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: topSpacing),

              /// Grid
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      itemCount: controller.components.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // layout unchanged
                        mainAxisSpacing: gridSpacing,
                        crossAxisSpacing: gridSpacing,
                        childAspectRatio: constraints.maxWidth < 360
                            ? 0.72
                            : 0.80,
                      ),
                      itemBuilder: (context, index) {
                        final isSelected = selectedIndex == index;
                        ComponentsModel component = controller.components.value[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              categoryId = component.id!;
                            });
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: const Color.fromRGBO(
                                      238,
                                      238,
                                      238,
                                      1,
                                    ),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.blue
                                          : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Image.network(
                                      "https://www.thebicyclestore.in/${component.icon!}",
                                      height: iconSize,
                                      width: iconSize,
                                      fit: BoxFit.contain,
                                    )
                                  ),
                                ),
                              ),

                              SizedBox(height: height * 0.01),

                              Text(
                                component.name!,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: textSize,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),

      /// Bottom Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            24,
          ),
          child: InkWell(
            onTap: () async {
              if(categoryId>0){
                await controller.getComponentItems(categoryId);
                Get.toNamed(AppRoutes.componentFitting,arguments: [categoryId,job]);
              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(CustomSnackbar.show(title: "Please select a component type", color: Colors.red[300]!));
              }
              
            },
            child: CustomButton(
              text: "Next",
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
    );
  }
}
