import 'dart:developer';
import 'dart:io';
import 'package:bicycle_app_technician/app/model/work_location_model.dart';
import 'package:http/http.dart' as http;
import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/app/modules/profile/profile_service.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:get/state_manager.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var reqId = 0.obs;

  RxList<WorkLocationModel> workLocations = <WorkLocationModel>[].obs;


  @override
  void onInit(){
    super.onInit();
    getData();
  }

  void getData() async {
    await getWorkLocations();
  }

  Future<bool> updateProfileReq (
    String phone,
    {String? email,
    File? image,}
  ) async {
    isLoading.value = true;

    try{
      final response = await ProfileService.updateProfile(phone, email:email,image: image);
      if(response.status && response.data!=null){
        reqId.value = response.data!["request_id"];
        return true;
      }
      hasError.value = true;
      errorMessage.value = response.message!;
      return false;
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      return false;
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<bool> verifyUpdateProfile (
    String otp
  ) async {
    isLoading.value = true;

    try{
      final response = await ProfileService.verifyUpdateOtp(reqId.value, otp);
      if(response.status && response.data!=null){
        await SharedPrefs.setString("first_name", response.data!.firstName!);
        await SharedPrefs.setString("last_name", response.data!.lastName!);
        await SharedPrefs.setString("email", response.data!.email!);
        await SharedPrefs.setString("image", response.data!.image!);
        await SharedPrefs.setString("phone", response.data!.phone!);
        return true;
      }
      hasError.value = true;
      errorMessage.value = response.message!;
      return false;
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      return false;
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<void> getWorkLocations() async {
    isLoading.value = true;
    try{
      final response = await ProfileService.getWorkLocations();
      if(response.status && response.data!=null){
        workLocations.value = response.data!;
      }
      hasError.value = true;
      errorMessage.value = response.message!;
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<bool> addWorkLocations(Map<String,dynamic> body) async {
    isLoading.value = true;
    try{
      final response = await ProfileService.addLocation(body);
      if(response.status == true){
        await getWorkLocations();
        return true;
      }
      hasError.value = true;
      errorMessage.value = response.message!;
      return false;
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      return false;
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<bool> deleteWorkLocations(int id) async {
    isLoading.value = true;
    try{
      final response = await ProfileService.deleteLocation(id);
      if(response.status == true){
        await getWorkLocations();
        return true;
      }
      hasError.value = true;
      errorMessage.value = response.message!;
      return false;
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      return false;
    }
    finally{
      isLoading.value = false;
    }
  }

  
}
