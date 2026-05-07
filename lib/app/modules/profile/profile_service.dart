import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/app/model/profile_details_model.dart';
import 'package:bicycle_app_technician/app/model/referral_history_model.dart';
import 'package:bicycle_app_technician/app/model/user_details_model.dart';
import 'package:bicycle_app_technician/app/model/work_location_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';

class ProfileService {
  static final baseUrl = ApiConstants.baseUrl;

  static Future<ApiResponseModel<Map<String, dynamic>>> updateProfile(
    String phone, {
    String? email,
    File? image,
  }) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");

    Map<String, String> payload = {};

    if (email == null) {
      payload = {"phone": phone};
    } else {
      payload = {"phone": phone, "email": email};
    }

    log("update payload: ${payload.toString()}");

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${baseUrl}profile/update-request"),
      );
      request.headers["Accept"] = 'application/json';
      request.headers["Authorization"] = "Bearer $token";
      request.fields.addAll(payload);
      if (image != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          "image",
          image.path,
        );
        request.files.add(multipartFile);
      }

      var streamedResp = await request.send();
      var response = await http.Response.fromStream(streamedResp);
      log("updateProfile resp: ${response.body}");
         final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
     
        return ApiResponseModel(
          status: true,
          message: jsonBody["message"],
          data: jsonBody["data"],
        );
      } else {
        return ApiResponseModel(
          status: false,
          message: jsonBody["message"],
        );
      }
    } catch (e) {
      return ApiResponseModel(status: false, message: "Error $e occurred");
    }
  }

  static Future<ApiResponseModel<ProfileDetailsModel>> verifyUpdateOtp(
    int reqId,
    String otp,
  ) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");

    try {
      final body = {"request_id": reqId, "otp": otp};
      final response = await http.post(
        Uri.parse("${baseUrl}profile/update-verify"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );
      log("updateVerify resp: ${response.body}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        return ApiResponseModel(
          status: jsonBody["success"],
          message: jsonBody["message"],
          data: ProfileDetailsModel.fromJson(jsonBody["data"]),
        );
      } else {
        return ApiResponseModel(
          status: false,
          message: "Statuscode ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponseModel(status: false, message: "error $e occurred");
    }
  }

  static Future<ApiResponseModel<List<WorkLocationModel>>>
  getWorkLocations() async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}work-locations"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      log("locationList resp: ${response.body}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        List<WorkLocationModel> jobList = [];
        for (var item in jsonBody["data"]) {
          jobList.add(WorkLocationModel.fromJson(item));
        }
        log("locationsList len: ${jobList.length}");

        return ApiResponseModel(
          status: jsonBody["success"],
          message: jsonBody["message"],
          data: jobList,
        );
      } else {
        return ApiResponseModel(
          status: false,
          message: "Statuscode ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponseModel(status: false, message: "error $e occurred");
    }
  }

  static Future<ApiResponseModel> addLocation(Map<String, dynamic> body) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}work-locations"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );
      log("addLocation resp: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonBody = jsonDecode(response.body);

        return ApiResponseModel(
          status: jsonBody["success"],
          message: jsonBody["message"],
        );
      } else {
        return ApiResponseModel(
          status: false,
          message: "Statuscode ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponseModel(status: false, message: "error $e occurred");
    }
  }

  static Future<ApiResponseModel> deleteLocation(int id) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");

    try {
      final response = await http.delete(
        Uri.parse("${baseUrl}work-locations/$id"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      log("delete location resp: ${response.body}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        return ApiResponseModel(
          status: jsonBody["success"],
          message: jsonBody["message"],
        );
      } else {
        return ApiResponseModel(
          status: false,
          message: "Statuscode ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponseModel(status: false, message: "error $e occurred");
    }
  }

  static Future<ApiResponseModel<dynamic>> getWalletDetails(int userId)async{
    try {
      final url = Uri.parse(
        "https://www.thebicyclestore.in/api/wallet/$userId",
      );
      debugPrint("Calling $url");
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      log("get Wallet resp: ${response.body}");
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return ApiResponseModel(
          status: data["status"],
          message: "Wallet fetched",
          data: data['pcs_wallet']
        );
      } else {
        return ApiResponseModel(
          status: data["status"],
          message: "Statuscode ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponseModel(status: false, message: "Error $e occurred");
    }
  }

  static Future<ApiResponseModel<ReferralHistoryModel>>
  getReferralHistory() async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}referrals"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      log("referral resp: ${response.body}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return ApiResponseModel(
          status: jsonBody["status"],
          message: jsonBody["message"],
          data: ReferralHistoryModel.fromJson(jsonBody["data"]),
        );
      } else {
        return ApiResponseModel(
          status: false,
          message: "Statuscode ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponseModel(status: false, message: "error $e occurred");
    }
  }

}
