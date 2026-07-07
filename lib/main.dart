import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:bicycle_app_technician/app/routes/app_pages.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/installr_efrerral.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

final AppLinks _appLinks = AppLinks();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefs.init();
  debugPrint('MAIN STARTED');
  String initialRoute = AppPages.initial;
  bool is1done = SharedPrefs.getBool("isStep1Done");
  bool is2done = SharedPrefs.getBool("isStep2Done");
  bool isVerified = SharedPrefs.getBool("isVerified");
  bool isLoggedIn = SharedPrefs.getBool("isLoggedIn");
  bool isVerificationPending = SharedPrefs.getBool("isVerificationPending");

  if (isLoggedIn) {
    debugPrint("BEFORE1 ");
    initialRoute = AppRoutes.bottomNav;
  } else if (isVerified && isLoggedIn) {
    log("jobList");
    debugPrint("BEFORE2 ");
    initialRoute = AppRoutes.bottomNav;
  } else if (isVerificationPending) {
    log("pending");
    debugPrint("BEFORE3 ");
    initialRoute = AppRoutes.identityPending;
  } else if (is2done && is1done && !isVerificationPending) {
    log("approved");
    debugPrint("BEFORE4 ");
    initialRoute = AppRoutes.identityApproved;
  } else if (is1done) {
    log("verification");
    debugPrint("BEFORE5 ");
    initialRoute = AppRoutes.verification;
  }
  debugPrint('STARTED INSTALLREFERRERSERVICE');
  await InstallReferrerService.init(); 
  await initAppLinks();
  debugPrint("BEFORE runApp");
  runApp(MainApp(initialRoute: initialRoute));
}

Future<void> initAppLinks() async {
  try {
    final Uri? uri = await _appLinks.getInitialLink();
    if (uri != null) {
      handleReferralLink(uri);
    }
    _appLinks.uriLinkStream.listen((Uri uri) {
      handleReferralLink(uri);
    });
  } catch (e) {
    debugPrint("AppLinks error: $e");
  }
}

Future<void> handleReferralLink(Uri uri) async {
  debugPrint('DEEP LINK RECEIVED => $uri');
  final code = uri.queryParameters['code'];
  if (code == null || code.isEmpty) {
    return;
  }
  debugPrint('REFERRAL CODE => $code');
  await SharedPrefs.setString('promo_code', code);
  debugPrint('PROMO SAVED => ${SharedPrefs.getString('promo_code')}');
  debugPrint('Referral Saved => $code');
}

class MainApp extends StatelessWidget {
  String initialRoute;
  MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: AppColors.appBg),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);

        return MediaQuery(
          data: mediaQuery.copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
