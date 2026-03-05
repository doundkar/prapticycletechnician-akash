import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/app/model/profile_details_model.dart';
import 'package:bicycle_app_technician/app/model/work_location_model.dart';
import 'package:http/http.dart' as http;
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';

class ProfileService {
  static final baseUrl = ApiConstants.baseUrl;

  static Future<ApiResponseModel<ProfileDetailsModel>> updateProfile(
    String firstName,
    String lastName,
    String email,
    File image,
  ) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");

    final payload = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
    };

    log("update payload: ${payload.toString()}");

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${baseUrl}profile/update"),
      );
      request.headers["Accept"] = 'application/json';
      request.headers["Authorization"] = "Bearer $token";
      request.fields.addAll(payload);
      var multipartFile = await http.MultipartFile.fromPath(
        "image",
        image.path,
      );
      request.files.add(multipartFile);
      var streamedResp = await request.send();
      var response = await http.Response.fromStream(streamedResp);
      log("updateProfile resp: ${response.body}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return ApiResponseModel(
          status: true,
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
      return ApiResponseModel(status: false, message: "Error $e occurred");
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

  static Future<ApiResponseModel> addLocation(Map<String,dynamic> body) async {
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
        body: jsonEncode(body)
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

}
