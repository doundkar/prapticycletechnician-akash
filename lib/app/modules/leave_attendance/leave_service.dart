import 'dart:convert';
import 'dart:developer';

import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/app/model/report_model.dart';
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class LeaveService {

  static final baseUrl = ApiConstants.baseUrl;

  static Future<ApiResponseModel<ReportModel>>
  getReport(int year, int month) async {
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
        return ApiResponseModel(status: true,message: "Report fetched successfully",data: ReportModel.fromJson(jsonBody["data"]));
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