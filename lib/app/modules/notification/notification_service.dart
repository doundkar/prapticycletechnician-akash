import 'dart:convert';
import 'dart:developer';

import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class NotificationService {

  static String baseUrl = ApiConstants.baseUrl;

  static Future<ApiResponseModel>
  getNotifications() async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}URL"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      log("notification resp: ${response.body}");
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