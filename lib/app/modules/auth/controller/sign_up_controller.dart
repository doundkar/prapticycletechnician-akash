import 'dart:developer';
import 'dart:io';

import 'package:bicycle_app_technician/app/modules/auth/service/auth_service.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var isStep1Completed = false.obs;
  var isStep2Completed = false.obs;
  var isVerified = false.obs;
  var isVerificationPending = true.obs;

  Future<void> signUp(Map<String, dynamic> body) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await AuthService.signup(body);
      if (response.status) {
        isStep1Completed.value = true;
        await SharedPrefs.setString("user_id", "${response.data["user_id"]}");
        await SharedPrefs.setString("phone", response.data["phone"]);
        await SharedPrefs.setBool("isStep1Done", true);
      } else {
        hasError.value = true;
        errorMessage.value = response.message!;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyDocuments({
    File? aadharFront,
    File? aadharBack,
    File? pancard,
  }) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await AuthService.uploadDocuments(
        aadharBack: aadharBack,
        aadharFront: aadharFront,
        pancard: pancard,
      );
      if (response.status) {
        isStep2Completed.value = true;
        await SharedPrefs.setBool("isStep2Done", true);
        await SharedPrefs.setBool("isVerificationPending", true);
      } else {
        hasError.value = true;
        errorMessage.value = response.message!;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getOtp() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await AuthService.isVerified();
      if (response.status) {
        isVerified.value = true;
        isVerificationPending.value = false;
        await SharedPrefs.setString("user_id", "${response.data["user_id"]}");
        // await SharedPrefs.setString("otp", "${response.data["otp"]}");
        // await SharedPrefs.setString("phone", response.data["phone"]);
        await SharedPrefs.setBool("isVerified", true);
        await SharedPrefs.setBool("isVerificationPending", false);
        await SharedPrefs.setBool("isLoggedIn", true);
      } else {
        isVerified.value = false;
        hasError.value = true;
        errorMessage.value = response.message!;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkVerification() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      String userIdStr = SharedPrefs.getString("user_id");
      int userId = int.parse(userIdStr);

      Map<String, dynamic> body = {"user_id": userId};

      final response = await AuthService.checkVerificationLogin(body);
      if (response.status) {
        await SharedPrefs.setBool("isLoggedIn", true);
        await SharedPrefs.setString("first_name", response.data!.firstName!);
        await SharedPrefs.setString("last_name", response.data!.lastName!);
        await SharedPrefs.setString("user_id", "${response.data!.id!}");
        await SharedPrefs.setString("email", response.data!.email!);
        await SharedPrefs.setString("phone", response.data!.phone!);
        await SharedPrefs.setString("image", response.data!.image!);
        await SharedPrefs.setString("token", response.data!.token!);
        await SharedPrefs.setString(
          "jobs_completed",
          response.data!.jobsCompleted!.toString(),
        );
        await SharedPrefs.setString(
          "ratings",
          response.data!.ratings.toString(),
        );
        await SharedPrefs.setString("promo_code", response.data!.promoCode!);
        log("${response.data}");
      } else {
        hasError.value = true;
        errorMessage.value = response.message!;
        log(" else error: ${errorMessage.value}");
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
      log(" catch error: ${errorMessage.value}");
    } finally {
      isLoading.value = false;
    }
  }
}
