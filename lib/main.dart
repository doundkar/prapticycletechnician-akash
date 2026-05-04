import 'dart:developer';

import 'package:bicycle_app_technician/app/routes/app_pages.dart';
import 'package:bicycle_app_technician/app/routes/app_routes.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';


 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefs.init();
  String initialRoute = AppPages.initial;
  bool is1done = SharedPrefs.getBool("isStep1Done");
  bool is2done = SharedPrefs.getBool("isStep2Done");
  bool isVerified = SharedPrefs.getBool("isVerified");
  bool isLoggedIn = SharedPrefs.getBool("isLoggedIn");
  bool isVerificationPending = SharedPrefs.getBool("isVerificationPending");


  if(isLoggedIn){
    initialRoute = AppRoutes.bottomNav;
  }
  else if(isVerified && isLoggedIn){
    log("jobList");
    initialRoute = AppRoutes.bottomNav;
  }
  else if(isVerificationPending){
    log("pending");
    initialRoute = AppRoutes.identityPending;
  }
  else if(is2done && is1done && !isVerificationPending){
    log("approved");
    initialRoute = AppRoutes.identityApproved;
  }
  else if(is1done){
    log("verification");
    initialRoute = AppRoutes.verification;
  }

  runApp(MainApp(initialRoute: initialRoute,));
}

class MainApp extends StatelessWidget {
  String initialRoute;
  MainApp({super.key,required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        scaffoldBackgroundColor: AppColors.appBg
      ),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
     builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaleFactor: 1.0, 
          ),
          child: child!,
        );
      },
    );
  }
}
