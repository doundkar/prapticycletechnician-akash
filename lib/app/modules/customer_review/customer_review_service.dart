import 'dart:convert';
import 'dart:developer';
import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class CustomerReviewService {

  static const baseUrl = ApiConstants.baseUrl;

  static Future<ApiResponseModel> postReview(Map<String,dynamic> body) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}job/review"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      log("postReview resp: ${response.body}");
      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiResponseModel(status: true, message: jsonBody["message"]);
      }
      return ApiResponseModel(status: false, message: jsonBody["message"]);
    } catch (e) {
      return ApiResponseModel(status: false, message: "Some error $e occurred");
    }
  }

}