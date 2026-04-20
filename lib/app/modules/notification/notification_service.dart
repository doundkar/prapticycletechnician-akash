import 'dart:convert';
import 'dart:developer';

import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/app/model/notification_model.dart';
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class NotificationService {

  static String baseUrl = ApiConstants.baseUrl;

  static Future<ApiResponseModel<List<NotificationModel>>>
  getNotifications() async {
    String token = SharedPrefs.getString("token");
    String userIdStr = SharedPrefs.getString("user_id");
    log("token: $token");
    try {
      final response = await http.get(
        Uri.parse("https://www.thebicyclestore.in/api/notifications/$userIdStr"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      // log("notification resp: ${response.body}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        List<NotificationModel> list = [];
        for(var item in jsonBody['data']){
          list.add(NotificationModel.fromJson(item));
        }
        return ApiResponseModel(
          status: true,
          message: "Date fetched",
          data: list
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

  static Future<bool> readNotificatoins() async {
    try {
      final userIdStr = SharedPrefs.getString("user_id");
      final userId = int.tryParse(userIdStr);
      final payload = {"user_id": userId};
      final url = Uri.parse("https://www.thebicyclestore.in/api/notification/read");
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );
      // log("All notifications marked as read");
      if(response.statusCode==200){
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clearNotificatoins() async {
    try {
      final userIdStr = SharedPrefs.getString("user_id");
      final userId = int.tryParse(userIdStr);
      final url = Uri.parse(
        "https://www.thebicyclestore.in/api/notifications/clear/$userId",
      );
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      final body = jsonDecode(response.body);
      log("All notifications marked as read");
      return body["status"];
    } catch (e) {
      return false;
    }
  }

}