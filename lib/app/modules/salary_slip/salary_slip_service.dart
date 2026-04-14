import 'dart:convert';
import 'dart:developer';
import 'package:bicycle_app_technician/app/model/salary_slip_model.dart';
import 'package:http/http.dart' as http;
import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';

class SalarySlipService {

  static final String baseUrl = ApiConstants.baseUrl;

  static Future<ApiResponseModel<SalarySlipModel>> getSalary(
    int year,
    int month,
  ) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    try {
      final body = {"month": month, "year": year};
      final request = http.Request("GET", Uri.parse("${baseUrl}salary-slip"));
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      request.body = jsonEncode(body);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      log("salary resp: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return ApiResponseModel(
          status: true,
          message: "Leaves fetched successfully",
          data: SalarySlipModel.fromJson(jsonBody["data"]),
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