import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/app/model/user_details_model.dart';
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class AuthService {

  static const baseUrl = ApiConstants.baseUrl;

  static Future<ApiResponseModel> signup(Map<String,dynamic> body) async {
    try {

      final response = await http.post(
        Uri.parse("${baseUrl}register-step1"),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body)
      );
      final jsonBody = jsonDecode(response.body);
      if(response.statusCode==200){
        log("signup resp: $jsonBody");
        final rawdata = jsonBody["data"];
        final data = {
          "user_id":rawdata["user_id"],
          "phone":rawdata["phone"]
        };
        return ApiResponseModel(status: jsonBody["status"],message: jsonBody["message"],data: data);
      }
      else{
        return ApiResponseModel(status: false,message: jsonBody["message"]);
      }
    } catch (e) {
      return ApiResponseModel(status: false,message: "Error $e occurred");
    }
  }

  static Future<ApiResponseModel> uploadDocuments({File? aadharFront,File? aadharBack,File? pancard}) async {

    final userIdStr = SharedPrefs.getString("user_id");
    final userId = int.parse(userIdStr);
    try {
      final body = {
        "user_id":userIdStr
      };
      
      var request = http.MultipartRequest("POST", Uri.parse("${baseUrl}register-step2"));
      request.headers["Accept"] = 'application/json';
      request.fields.addAll(body);
      request.files.add(
        await http.MultipartFile.fromPath("aadhaar_front", aadharFront!.path)
      );
      request.files.add(
        await http.MultipartFile.fromPath("aadhaar_back", aadharBack!.path)
      );
      request.files.add(
        await http.MultipartFile.fromPath("pan_card", pancard!.path)
      );

      var streamedResp = await request.send();
      var response = await http.Response.fromStream(streamedResp);
      final jsonBody = jsonDecode(response.body);
      if(response.statusCode==200){
        log("upload resp: $jsonBody");
        final data = jsonBody["data"];
        return ApiResponseModel(status: jsonBody["status"],message: jsonBody["message"],data: data);
      }
      else{
        return ApiResponseModel(status: false,message: jsonBody["message"]);
      }
    } catch (e) {
      return ApiResponseModel(status: false,message: "Error $e occurred");
    }
  }

  static Future<ApiResponseModel> isVerified() async {

    final phone = SharedPrefs.getString("phone");

    try {

      Map<String,dynamic> body = {
        "phone": phone
      };

      final response = await http.post(
        Uri.parse("${baseUrl}send-otp"),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body)
      );

      if(response.statusCode==200){
        final jsonBody = jsonDecode(response.body);
        log("otp resp: $jsonBody");
        final rawdata = jsonBody["data"];
        final data = {
          "user_id":rawdata["user_id"],
          "otp":rawdata["otp"]
        };
        return ApiResponseModel(status: jsonBody["success"],message: jsonBody["message"],data: data);
      }
      else{
        log("not verified yet");
        return ApiResponseModel(status: false,message: "Not verified yet");
      }
    } catch (e) {
      return ApiResponseModel(status: false,message: "Error $e occurred");
    }
  }

  static Future<ApiResponseModel> getOtp(String phone) async {

    try {

      Map<String,dynamic> body = {
        "phone": phone
      };

      final response = await http.post(
        Uri.parse("${baseUrl}send-otp"),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body)
      );

      if(response.statusCode==200){
        final jsonBody = jsonDecode(response.body);
        log("otp resp: $jsonBody");
        final rawdata = jsonBody["data"];
        final data = {
          "user_id":rawdata["user_id"],
          "otp":rawdata["otp"]
        };
        return ApiResponseModel(status: jsonBody["success"],message: jsonBody["message"],data: data);
      }
      else{
        log("not verified yet");
        return ApiResponseModel(status: false,message: "Not verified yet");
      }
    } catch (e) {
      return ApiResponseModel(status: false,message: "Error $e occurred");
    }
  }

  static Future<ApiResponseModel<UserDetailsModel>> verifyOtp(Map<String,dynamic> body) async {

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}verify-otp"),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body)
      );

      if(response.statusCode==200){
        final jsonBody = jsonDecode(response.body);
        // log("verify otp resp: $jsonBody");
        final data = jsonBody["data"];
        return ApiResponseModel(status: jsonBody["success"],message: jsonBody["message"],data: UserDetailsModel.fromJson(data));
      }
      else{
        log("verification error");
        return ApiResponseModel(status: false,message: "Not verified yet");
      }
    } catch (e) {
      return ApiResponseModel(status: false,message: "Error $e occurred");
    }
  }

  static Future<ApiResponseModel<UserDetailsModel>> checkVerificationLogin(Map<String,dynamic> body) async {

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}check-verification-login"),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body)
      );

      if(response.statusCode==200){
        final jsonBody = jsonDecode(response.body);
        log("check verify resp: $jsonBody");
        final data = jsonBody["data"];
        return ApiResponseModel(status: jsonBody["success"],message: jsonBody["message"],data: UserDetailsModel.fromJson(data));
      }
      else{
        log("check verification error");
        return ApiResponseModel(status: false,message: "Not verified yet");
      }
    } catch (e) {
      return ApiResponseModel(status: false,message: "Error $e occurred");
    }
  }

}
