import 'dart:developer';

import 'package:bicycle_app_technician/app/modules/auth/service/auth_service.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  Future<void> getOtp(String phone) async {

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try{
      final response = await AuthService.getOtp(phone);
      log("${response.data}");
      if(response.status){
        await SharedPrefs.setString("user_id", "${response.data["user_id"]}");
        await SharedPrefs.setString("otp", "${response.data["otp"]}");
        await SharedPrefs.setString("phone",phone);
        log("${response.data}");
      }
      else{
        hasError.value = true;
        errorMessage.value = response.message!;
        log(" else error: ${errorMessage.value}");
      }
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
      log(" catch error: ${errorMessage.value}");
    }
    finally{
      isLoading.value = false;
    }

  }

  Future<void> verifyOtp(String otp) async {

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try{

      String userIdStr = SharedPrefs.getString("user_id");
      int userId = int.parse(userIdStr);

      Map<String,dynamic> body = {
        "user_id":userId,
        "otp":otp
      };

      final response = await AuthService.verifyOtp(body);
      if(response.status){
        await SharedPrefs.setBool("isLoggedIn", true);
        await SharedPrefs.setString("first_name",response.data!.firstName!);
        await SharedPrefs.setString("last_name",response.data!.lastName!);
        await SharedPrefs.setString("user_id","${response.data!.id!}");
        await SharedPrefs.setString("email",response.data!.email!);
        await SharedPrefs.setString("phone",response.data!.phone!);
        await SharedPrefs.setString("token",response.data!.token!);
        log("${response.data}");
      }
      else{
        hasError.value = true;
        errorMessage.value = response.message!;
        log(" else error: ${errorMessage.value}");
      }
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
      log(" catch error: ${errorMessage.value}");
    }
    finally{
      isLoading.value = false;
    }

  }

}
