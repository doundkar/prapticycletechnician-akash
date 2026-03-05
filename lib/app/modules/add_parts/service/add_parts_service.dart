import 'dart:convert';
import 'dart:developer';

import 'package:bicycle_app_technician/app/model/api_response_model.dart';
import 'package:bicycle_app_technician/app/model/component_items_model.dart';
import 'package:bicycle_app_technician/app/model/components_model.dart';
import 'package:bicycle_app_technician/utils/api_constants.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class AddPartsService {
  static final String partsBaseUrl = ApiConstants.partsBaseUrl;
  static final String baseUrl = ApiConstants.baseUrl;

  static Future<ApiResponseModel<List<ComponentsModel>>> getComponents() async {
    try {
      final response = await http.get(
        Uri.parse("${partsBaseUrl}components"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      log("getComponents resp: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        List<ComponentsModel> components = [];
        for (var component in jsonBody["data"]) {
          components.add(ComponentsModel.fromJson(component));
        }

        return ApiResponseModel(
          status: jsonBody["status"],
          message: "Components fetched successfully",
          data: components,
        );
      }
      return ApiResponseModel(
        status: false,
        message: "Components couldn't be fetched",
      );
    } catch (e) {
      return ApiResponseModel(status: false, message: "Some error $e occurred");
    }
  }

  static Future<ApiResponseModel<List<ComponentItemsModel>>> getComponentItems(
    int categoryId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("${partsBaseUrl}components-items/$categoryId"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      log("getComponentItems resp: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final rawData = jsonBody["data"];
        List<ComponentItemsModel> components = [];
        ComponentItemsModel.currentPage = rawData["current_page"];
        ComponentItemsModel.lastPage = rawData["last_page"];
        for (var component in rawData["data"]) {
          components.add(ComponentItemsModel.fromJson(component));
        }

        return ApiResponseModel(
          status: jsonBody["status"],
          message: "Components fetched successfully",
          data: components,
        );
      }
      return ApiResponseModel(
        status: false,
        message: "Components couldn't be fetched",
      );
    } catch (e) {
      return ApiResponseModel(status: false, message: "Some error $e occurred");
    }
  }

  static Future<ApiResponseModel<List<ComponentItemsModel>>> loadMoreComponentItems(
    int categoryId,
    int page
  ) async {
    try {
      final response = await http.get(
        Uri.parse("${partsBaseUrl}components-items/$categoryId?page=$page"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      log("getComponentItems resp: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final rawData = jsonBody["data"];
        List<ComponentItemsModel> components = [];
        ComponentItemsModel.currentPage = rawData["current_page"];
        ComponentItemsModel.lastPage = rawData["last_page"];
        for (var component in rawData["data"]) {
          components.add(ComponentItemsModel.fromJson(component));
        }

        return ApiResponseModel(
          status: jsonBody["status"],
          message: "Components fetched successfully",
          data: components,
        );
      }
      return ApiResponseModel(
        status: false,
        message: "Components couldn't be fetched",
      );
    } catch (e) {
      return ApiResponseModel(status: false, message: "Some error $e occurred");
    }
  }

  static Future<ApiResponseModel> sendApprovalNotification(int jobId, List<Map<String, dynamic>> items) async {
    String token = SharedPrefs.getString("token");
    log("token: $token");
    log("jobId: $jobId");
    final payload = {
      "job_id": "$jobId",
      "note": "Pay ASAP",
      "service_items":items
      };

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}approval-notification"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(payload)
      );
      log("approval resp: ${response.body}");
      if(response.statusCode == 200){
        final jsonBody = jsonDecode(response.body);
        return ApiResponseModel(status: true,message: jsonBody["message"]);
      }
      else{ 
        return ApiResponseModel(status: false,message: "Statuscode ${response.statusCode}");
      }
    } catch (e) {
      return ApiResponseModel(status: false,message: "Error $e occurred");
    }
  }

}
