import 'dart:convert';
import 'dart:developer';

import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class JobListService {
  static final String baseUrl = ApiConstants.baseUrl;

  static Future<ApiResponseModel<List<JobDetailsModel>>>
  getNewJobRequests() async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}jobslist?per_page=10"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      log("newJobList resp: ${response.body}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        List<JobDetailsModel> jobList = [];
        for (var item in jsonBody["data"]) {
          jobList.add(JobDetailsModel.fromJson(item));
        }
        log("joblist len: ${jobList.length}");

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

  static Future<ApiResponseModel<List<JobDetailsModel>>>
  getAcceptedJobRequests() async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}jobs/accepted?per_page=10"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      log("acceptedJobList resp: ${response.body}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        List<JobDetailsModel> jobList = [];
        for (var item in jsonBody["data"]) {
          jobList.add(JobDetailsModel.fromJson(item));
        }
        log("joblist len: ${jobList.length}");

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

  static Future<ApiResponseModel> acceptJobRequest(int jobId) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    log("jobId: $jobId");

    final payload = {
      "job_id" : jobId
    };

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}job-accept"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload)
      );
      log("jobAccept resp: ${response.body}");
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

  static Future<ApiResponseModel> rejectJobRequest(int jobId) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");

    final payload = {
      "job_id" : jobId
    };

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}reject-job"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload)
      );
      log("jobReject resp: ${response.body}");
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


  static Future<ApiResponseModel<bool>> toggleActivity(bool activity) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");

    final payload = {
      "is_online": activity
    };

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}status"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload)
      );
      log("toogleActivity resp: ${response.body}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final data = jsonBody["data"];
        return ApiResponseModel(
          status: jsonBody["success"],
          message: jsonBody["message"],
          data: data["is_online"]
        );
      } else {
        return ApiResponseModel(
          status: false,
          message: "Statuscode ${response.statusCode}",
          data: false
        );
      }
    } catch (e) {
      return ApiResponseModel(status: false, message: "error $e occurred",data: false);
    }
  }


}
