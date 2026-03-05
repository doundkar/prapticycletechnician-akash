import 'dart:convert';
import 'dart:developer';

import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/app/model/leave_model.dart';
import 'package:bicycle_app_technician/app/model/report_model.dart';
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class LeaveService {
  static final baseUrl = ApiConstants.baseUrl;

  static Future<ApiResponseModel<ReportModel>> getReport(
    int year,
    int month,
  ) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}attendance/report?year=$year&month=$month"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      log("report resp: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return ApiResponseModel(
          status: true,
          message: "Report fetched successfully",
          data: ReportModel.fromJson(jsonBody["data"]),
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

  static Future<ApiResponseModel<List<LeaveModel>>> getLeaves(
    int year,
    int month,
  ) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    try {
      final body = {"month": month, "year": year};
      final request = http.Request("GET", Uri.parse("${baseUrl}leave/my"));
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      request.body = jsonEncode(body);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      log("report resp: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<LeaveModel> leaves = [];
        for (var json in jsonBody["data"]) {
          LeaveModel l = LeaveModel.fromJson(json);
          if(l.status! == "approved"){
            log("leave : ${l.id}");
            leaves.add(l);
          }
        }
        return ApiResponseModel(
          status: true,
          message: "Leaves fetched successfully",
          data: leaves,
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

  static Future<ApiResponseModel> appyLeave(Map<String,dynamic> body) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}leave/request"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body)
      );
      log("apply leave resp: ${response.body}");
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

}
