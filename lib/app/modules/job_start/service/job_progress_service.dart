import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class JobProgressService {
  static final String baseUrl = ApiConstants.baseUrl;

  static Future<ApiResponseModel> verifyJobStartOtp(int jobId, int otp) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    log("jobId: $jobId");

    final payload = {"job_id": jobId, "otp": otp};

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}job/verify-otp"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      log("verifyStartOtp resp: ${response.body}");
      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiResponseModel(status: true, message: jsonBody["message"]);
      }
      return ApiResponseModel(status: false, message: jsonBody["message"]);
    } catch (e) {
      return ApiResponseModel(status: false, message: "Some error $e occurred");
    }
  }

  static Future<ApiResponseModel> startJob(int jobId, List<File> images) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    log("jobId: $jobId");

    final payload = {"job_id": "$jobId"};

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${baseUrl}job/start"),
      );
      request.headers["Accept"] = 'application/json';
      request.headers["Authorization"] = "Bearer $token";
      request.fields.addAll(payload);
      for (int i = 0; i < images.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath("photos[]", images[i].path),
        );
      }
      var streamedResp = await request.send();
      var response = await http.Response.fromStream(streamedResp);
      log("startJob resp: ${response.body}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return ApiResponseModel(status: true, message: jsonBody["message"]);
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

  static Future<ApiResponseModel> completeJob(
    int jobId,
    List<File> images,
    int timeTaken,
    int otp,
    List<dynamic> parts,
  ) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    log("jobId: $jobId");

    final payload = {
      "job_id": jobId.toString(),
      "otp": otp.toString(),
      "total_time_seconds": timeTaken.toString(),
    };

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${baseUrl}job/complete"),
      );
      request.headers["Accept"] = 'application/json';
      request.headers["Authorization"] = "Bearer $token";
      request.fields.addAll(payload);
      for (int i = 0; i < images.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath("after_photos[]", images[i].path),
        );
      }
      for (var part in parts) {
        request.fields.addAll({"parts[]": part.toString()});
      }
      var streamedResp = await request.send();
      var response = await http.Response.fromStream(streamedResp);
      log("endJob resp: ${response.body}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return ApiResponseModel(status: true, message: jsonBody["message"]);
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
}
