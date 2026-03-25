import 'dart:async';

import 'package:bicycle_app_technician/app/modules/profile/profile_controller.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  ProfileController controller = Get.put(ProfileController());
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
      promoCode = SharedPrefs.getString("promo_code");
      pcsAmt = SharedPrefs.getString("pcs_wallet");
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
      appBar: CustomAppBar(title: "Wallet", isBackNeeded: false),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOTAL CREDITS CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/earnings.png",
                        height: 73,
                        width: 73,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Credits",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(75, 79, 99, 1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "₹$pcsAmt",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(75, 79, 99, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// TITLE
                const Text(
                  "Your Recent Transactions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(51, 61, 76, 1),
                  ),
                ),

                const SizedBox(height: 16),

                /// LIST
                // Expanded(
                //   child: ListView(
                //     children: [
                //       transactionTile("₹250", "#OrderID1245789"),
                //       transactionTile("₹250", "#OrderID1245789"),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return transactionTile(
                        controller.referral.value!.referrals![index].amount!
                            .toString(),
                        controller.referral.value!.referrals![index].name!,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 12);
                    },
                    itemCount: controller.referral.value!.referrals!.length,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// 🔹 Transaction Tile Method
  Widget transactionTile(String amount, String name) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_downward, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹$amount",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name.capitalize!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // const Icon(
            //   Icons.chevron_right,
            //   color: Color.fromRGBO(51, 61, 76, 1),
            // ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 12),
      ],
    );
  }
}
