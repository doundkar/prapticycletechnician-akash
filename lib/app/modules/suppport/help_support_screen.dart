import 'package:bicycle_app_technician/app/model/support_model.dart';
import 'package:bicycle_app_technician/app/modules/suppport/support_controller.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:get/get.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  /// FAQ Section expanded index
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isTablet = width >= 768;
    final bool isSmallPhone = width < 360;

    final double padding = isTablet
        ? 24
        : isSmallPhone
        ? 12
        : 16;
    final double titleFont = isTablet ? 18 : 16;
    final double textFont = isTablet
        ? 15
        : isSmallPhone
        ? 13
        : 14;
    final double spacingLarge = isTablet ? 24 : 20;
    final double spacingMedium = isTablet ? 20 : 16;

    SupportController controller = Get.find();

    return Scaffold(
      appBar: CustomAppBar(title: "Help & Support"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: SizedBox(
              height: 30,
              width: 30,
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
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Intro Text
              Text(
                "We're here to help you with jobs, payments, and app issues.",
                style: TextStyle(color: Colors.grey, fontSize: textFont),
              ),

              SizedBox(height: spacingLarge),

              /// CALL SUPPORT CARD
              _cardContainer(
                context,
                isTablet: isTablet,
                isSmallPhone: isSmallPhone,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.call_outlined),
                        const SizedBox(width: 8),
                        Text(
                          controller.support.value!.callSupport!.title!,
                          style: TextStyle(
                            fontSize: titleFont,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Text(
                      controller.support.value!.callSupport!.subtitle!,
                      style: TextStyle(fontSize: textFont),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.support.value!.callSupport!.availability!,
                      style: TextStyle(color: Colors.grey, fontSize: textFont),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Call: +91 ${controller.support.value!.callSupport!.phone}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: textFont,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: spacingMedium),

              /// CHAT SUPPORT CARD
              _cardContainer(
                context,
                isTablet: isTablet,
                isSmallPhone: isSmallPhone,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline),
                        const SizedBox(width: 8),
                        Text(
                          "Chat Support",
                          style: TextStyle(
                            fontSize: titleFont,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Instant help via chat for job issues, delays, app problems",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: textFont,
                            ),
                          ),
                        ),
                        SizedBox(width: isTablet ? 16 : 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 20 : 12,
                              vertical: isTablet ? 12 : 8,
                            ),
                          ),
                          child: Text(
                            "Start Chat",
                            style: TextStyle(fontSize: textFont),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: spacingMedium),

              /// EMAIL SUPPORT CARD
              _cardContainer(
                context,
                isTablet: isTablet,
                isSmallPhone: isSmallPhone,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.email_outlined),
                        const SizedBox(width: 8),
                        Text(
                          controller.support.value!.emailSupport!.title!,
                          style: TextStyle(
                            fontSize: titleFont,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Text(
                      controller.support.value!.emailSupport!.email!,
                      style: TextStyle(fontSize: textFont),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.support.value!.emailSupport!.responseTime!,
                      style: TextStyle(color: Colors.grey, fontSize: textFont),
                    ),
                    // const SizedBox(height: 12),
                    // TextField(
                    //   style: TextStyle(fontSize: textFont),
                    //   decoration: InputDecoration(
                    //     hintText: "Search help topics...",
                    //     prefixIcon: const Icon(Icons.search),
                    //     filled: true,
                    //     fillColor: Colors.grey.shade100,
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(
                    //         isTablet ? 16 : 12,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),

              SizedBox(height: spacingLarge),

              ...controller.support.value!.faqSections!.map((e) {
                return Column(
                  children: [
                    _faqSection(
                      context,
                      title: e.title!,
                      items: e.items!,
                      isTablet: isTablet,
                      textFont: textFont,
                    ),
                    SizedBox(height: spacingMedium),
                  ],
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  /// Reusable Card Container
  Widget _cardContainer(
    BuildContext context, {
    required Widget child,
    required bool isTablet,
    required bool isSmallPhone,
  }) {
    return Container(
      padding: EdgeInsets.all(
        isTablet
            ? 20
            : isSmallPhone
            ? 12
            : 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }

  /// FAQ Section
  Widget _faqSection(
    BuildContext context, {
    required String title,
    required List<Items> items,
    required bool isTablet,
    required double textFont,
  }) {
    return _cardContainer(
      context,
      isTablet: isTablet,
      isSmallPhone: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: textFont),
          ),
          const Divider(height: 20),
          ...items.asMap().entries.map((entry) {
            int index = entry.key;
            Items item = entry.value;

            bool isExpanded = expandedIndex == index;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.question!,
                        style: TextStyle(fontSize: textFont),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (expandedIndex == index) {
                            expandedIndex = null;
                          } else {
                            expandedIndex = index;
                          }
                        });
                      },
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.arrow_forward_ios,
                        size: 14,
                      ),
                    ),
                  ],
                ),

                if (isExpanded) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.answer!,
                    style: TextStyle(
                      fontSize: textFont - 1,
                      color: Colors.grey,
                    ),
                  ),
                ],

                const SizedBox(height: 12),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
