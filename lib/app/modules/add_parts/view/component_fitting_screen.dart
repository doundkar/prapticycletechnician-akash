import 'dart:developer';

import 'package:bicycle_app_technician/app/model/component_items_model.dart';
import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/modules/add_parts/controllers/add_parts_controller.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/widgets/custom_button.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class ComponentFittingScreen extends StatefulWidget {
  const ComponentFittingScreen({super.key});

  @override
  State<ComponentFittingScreen> createState() => _ComponentFittingScreenState();
}

class _ComponentFittingScreenState extends State<ComponentFittingScreen> {
  final double _bottomBarHeight = 90;

  dynamic args = Get.arguments;
  late int categoryId;
  late JobDetailsModel job;

  AddPartsController controller = Get.find();
  final ScrollController _scrollController = ScrollController();

  bool _isLoadingMore = false;


  @override
  void initState() {
    super.initState();
    // controller.getComponentItems(categoryId);
    log("curr page: ${ComponentItemsModel.currentPage!}");
    log("last page: ${ComponentItemsModel.lastPage!}");
    categoryId = args[0];
    job = args[1];
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && (ComponentItemsModel.currentPage! < ComponentItemsModel.lastPage!)) {
        loadMore();
      }
    }
  }

  Future<void> loadMore() async {
    _isLoadingMore = true;
    await controller.loadMoreComponentItems(
      categoryId,
      ComponentItemsModel.currentPage! + 1,
    );
    log("curr page: ${ComponentItemsModel.currentPage!}");
    log("last page: ${ComponentItemsModel.lastPage!}");
    _isLoadingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Component Fitting"),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.blue,
              ),
            ),
          );
        }
        if (controller.hasError.value) {
          return Center(
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.grey, size: 30),
                const SizedBox(height: 10),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
          );
        }
        if(controller.componentItems.isEmpty){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.block,size: 80,color: AppColors.blue,),
                const SizedBox(height: 10,),
                Text("No items available",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),)
              ],
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
            bottom:
                12 +  MediaQuery.of(context).padding.bottom,
          ),
          itemCount: controller.componentItems.length,
          controller: _scrollController,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = controller.componentItems.value[index];
            final qty = item.qty!;

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

                        /// Add / Qty Button
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Center(
                            child: SizedBox(
                              width: 110,
                              height: 32,
                              child: qty == 0
                                  ? ElevatedButton(
                                      onPressed: () {
                                        item.qty++;
                                        controller.extraItems.add(item);
                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        elevation: 4,
                                      ),
                                      child: const Text(
                                        'Add',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.blue,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.remove,
                                              size: 18,
                                              color: Colors.lightBlue,
                                            ),
                                            onPressed: () {
                                              if (item.qty > 1) {
                                                controller.extraItems.remove(item);
                                                item.qty--;
                                                controller.extraItems.add(item);
                                              } else {
                                                item.qty = 0;
                                                controller.extraItems.remove(item);
                                              }
                                              setState(() {});
                                            },
                                          ),
                                          Text(
                                            '$qty',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.add,
                                              size: 18,
                                              color: Colors.lightBlue,
                                            ),
                                            onPressed: () {
                                              controller.extraItems.remove(item);
                                              item.qty++;
                                              controller.extraItems.add(item);
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
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

                        // const SizedBox(height: 4),

                        if (item.size!.isNotEmpty)
                          Text(
                            'Size - ${item.size}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),

                        const SizedBox(height: 4),

                        Text(
                          '₹${item.price!}',
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
        );
      }),

      /// Bottom Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.approval,arguments: job);
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
