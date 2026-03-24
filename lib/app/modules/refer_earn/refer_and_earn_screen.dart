import 'dart:async';

import 'package:bicycle_app_technician/app/modules/profile/profile_controller.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  bool isExpanded = true;

  ProfileController controller = Get.find();
  late String promoCode;
  late String pcsAmt;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getData();
    timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      await controller.fetchPcsWallet(isInitial: false);
      await controller.fetchHistory(isInitial: false);
    });
  }

  void getData() async {
    await controller.fetchPcsWallet();
    await controller.fetchHistory();
    promoCode = SharedPrefs.getString("promo_code");
    pcsAmt = SharedPrefs.getString("pcs_wallet");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Refer and Earn",onTap: (){
        Get.back();
        timer!.cancel();
      } ,),
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
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔵 Top Purple Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(73, 94, 210, 1),
                        Color.fromRGBO(91, 53, 156, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(100),
                        child: Image.asset(
                          'assets/refer_coins.png',
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Invite friends to join us as Technicians\n",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: "and earn",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: " ₹50",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: " for every successful invite",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
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

                /// 🔵 Referral Code Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Referral of your code",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Referral Code Box
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                promoCode,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.copy),
                              label: Text(
                                "Copy",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(106, 106, 106, 1),
                                ),
                              ),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: promoCode),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(
                                      16,
                                    ), // prevents touching screen edges
                                    backgroundColor: Colors.green[300],
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    content: const Text(
                                      "Code Copied",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Share Button
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Share.share(promoCode);
                          },
                          child: const Text(
                            "Share & Earn Now",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔵 Share On Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Or Share on",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          shareItem("Facebook"),
                          shareItem("WhatsApp"),
                          shareItem("Mail"),
                          shareItem("Link"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔵 Earnings Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/earnings.png',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Total Earnings",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "₹$pcsAmt",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// Expandable Referrals
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Referrals",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          // Icon(
                          //   isExpanded
                          //       ? Icons.keyboard_arrow_up
                          //       : Icons.keyboard_arrow_down,
                          // ),
                        ],
                      ),

                      // if (isExpanded) ...[
                      //   const SizedBox(height: 16),
                      //   referralItem("Megha", "₹250"),
                      //   const SizedBox(height: 12),
                      //   referralItem("Ankit", "₹250"),
                      // ],
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return referralItem(
                            controller.referral.value!.referrals![index].name!,
                            controller.referral.value!.referrals![index].amount!
                                .toString(),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 12);
                        },
                        itemCount: controller.referral.value!.referrals!.length,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// 🔹 Share Item Widget
  Widget shareItem(String title) {
    String imagePath = '';

    if (title == "Facebook") {
      imagePath = 'assets/facebook.png';
    } else if (title == "WhatsApp") {
      imagePath = 'assets/whatsapp.png';
    } else if (title == "Mail") {
      imagePath = 'assets/gmail.png';
    } else {
      imagePath = 'assets/link.png';
    }

    return InkWell(
      onTap: () async {
        if (promoCode.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(
                16,
              ), // prevents touching screen edges
              backgroundColor: Colors.red[300],
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.transparent),
              ),
              content: const Text(
                "Promo code not available",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        } else {
          final referralLink =
              "https://thebicyclestore.in/refer/?code=$promoCode";
          if (title == "Facebook") {
            controller.shareOnFacebook(referralLink);
          }
          if (title == "WhatsApp") {
            controller.shareOnWhatsApp(referralLink);
          }
          if (title == "Mail") {
            controller.shareViaEmail(referralLink);
          } else {
            Clipboard.setData(ClipboardData(text: referralLink));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(
                  16,
                ), // prevents touching screen edges
                backgroundColor: Colors.green[300],
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.transparent),
                ),
                content: const Text(
                  "Link copied to clipboard",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade100,

            child: Image.asset(imagePath, height: 36, width: 36),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// 🔹 Referral Item
  Widget referralItem(String name, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name.capitalize!),
        Row(
          children: [
            Text(
              "₹$amount",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 247, 232, 1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "Completed",
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(0, 136, 79, 1),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
