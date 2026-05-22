import 'dart:developer';
import 'dart:io';
import 'package:bicycle_app_technician/app/model/referral_history_model.dart';
import 'package:bicycle_app_technician/app/model/work_location_model.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/app/modules/profile/profile_service.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:get/state_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var reqId = 0.obs;

  RxList<WorkLocationModel> workLocations = <WorkLocationModel>[].obs;
  Rxn<ReferralHistoryModel> referral = Rxn();

  @override
  void onInit()async{
    super.onInit();
    getData();
    await getRefferalAmount();
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
       Get.snackbar("Error", response.message.toString(),backgroundColor: Colors.red,duration: Duration(seconds: 5));
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

  Future<void> shareOnWhatsApp(String referralLink) async {
    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/?text=${Uri.encodeComponent(referralLink)}",
    );

    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  }

  Future<void> shareOnFacebook(String referralLink) async {
    final Uri fbUrl = Uri.parse(
      "fb-messenger://share/?link=${Uri.encodeComponent(referralLink)}",
    );

    await launchUrl(fbUrl, mode: LaunchMode.externalApplication);
  }

  Future<void> shareViaEmail(String referralLink) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      query: Uri.encodeFull(
        'subject=Join This App&body=Check this out:\n$referralLink',
      ),
    );

    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  }

  Future<void> fetchPcsWallet({bool isInitial = true}) async {
    if(isInitial){
      isLoading.value = true;
    }
    hasError.value = false;
    errorMessage.value = '';
    try {
      String userIdStr = SharedPrefs.getString("user_id");
      int userId = int.parse(userIdStr);
      final resp = await ProfileService.getWalletDetails(userId);
      if (resp.status && resp.data != null) {
        log("PCS CASH: ${resp.data}");
        await SharedPrefs.setString("pcs_wallet", resp.data!.toString());
        log("Stored PCS wallet bal to sharedPRefs");
      } else {
        hasError.value = true;
        errorMessage.value = resp.message!;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHistory({bool isInitial = true}) async {
    if(isInitial){
      isLoading.value = true;
    }
    hasError.value = false;
    errorMessage.value = '';
    try {
      final resp = await ProfileService.getReferralHistory();
      if (resp.status && resp.data != null) {
        referral.value = resp.data!;
      } else {
        hasError.value = true;
        errorMessage.value = resp.message!;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
    } finally {
      isLoading.value = false;
    }
  }


 
  Future<void>getRefferalAmount()async{
    final response = await ProfileService.getReferralAmount();
  }
}
