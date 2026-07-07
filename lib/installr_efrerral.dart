import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:play_install_referrer/play_install_referrer.dart';

class InstallReferrerService {
  static Future<void> init() async {
    try {
      //       final ReferrerDetails details =
      //           await PlayInstallReferrer.installReferrer;

      //       debugPrint('REFERRER DETAILS => $details');
      //  debugPrint("====================================");
      //       // Print all available values
      //       debugPrint(
      //         'INSTALL REFERRER => ${details.installReferrer}',
      //       );
      //          debugPrint("====================================");

      //       final String referrer =
      //           details.installReferrer ?? '';

      //       if (referrer.contains('code=')) {
      //   debugPrint("Referral code found in referrer");

      //   final uri = Uri.parse("https://thebicyclestore.in/?$referrer");

      //   final promoCode = uri.queryParameters['code'];

      //   debugPrint("PROMO CODE => $promoCode");

      //   if (promoCode != null && promoCode.isNotEmpty) {
      //     await SharedPrefs.setString("promo_user", promoCode);

      //     debugPrint("PROMO SAVED => $promoCode");
      //   }
      // } else {
      //   debugPrint("No referral code found in install referrer.");
      // }
      //         if (Get.isRegistered<LoginController>()) {
      //         Get.find<LoginController>().refreshReferral();
      //       }

      final details = await PlayInstallReferrer.installReferrer;
      debugPrint('REFERRER DETAILS => $details');
      debugPrint(details.installReferrer);

      final referrer = details.installReferrer ?? '';
      debugPrint('INSTALL REFERRER => ${details.installReferrer}');
      if (referrer.isNotEmpty) {
        final code = Uri.splitQueryString(referrer)['code'];

        if (code != null) {
          await SharedPrefs.setString("promo_code", code);

          debugPrint("PROMO = $code");
        } else {
          debugPrint("No PROMO CODE");
        }
      } else {
        debugPrint("REFERRER EMPTY");
      }
    } catch (e) {
      debugPrint('Install Referrer Error => $e');
    }
  }
}
