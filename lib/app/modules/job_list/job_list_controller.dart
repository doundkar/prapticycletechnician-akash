import 'dart:async';
import 'dart:developer';

import 'package:bicycle_app_technician/app/model/job_details_model.dart';
import 'package:bicycle_app_technician/app/modules/job_list/job_list_service.dart';
import 'package:bicycle_app_technician/utils/shared_prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class JobListController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var isAcceptClicked = false.obs;
  var isRejectClicked = true.obs;

  var allJobsCount = 0.obs;
  var pendingCount = 0.obs;
  var completedCount = 0.obs;

  var isOnline = false.obs;

  RxList<JobDetailsModel> newJobRequests = <JobDetailsModel>[].obs;
  RxList<JobDetailsModel> pendingJobRequests = <JobDetailsModel>[].obs;
  RxList<JobDetailsModel> acceptedJobRequests = <JobDetailsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    await getNewJobRequests();
    await getAcceptedJobRequests();
    Timer.periodic(Duration(minutes: 5), (_) {
      getNewJobRequests(isInitial: false); // silent refresh
    });
  }

  Future<void> getNewJobRequests({bool isInitial = true}) async {
    if (isInitial) {
      isLoading.value = true;
    }
    hasError.value = false;
    errorMessage.value = "";
    try {
      final response = await JobListService.getNewJobRequests();
      if (response.status && response.data != null) {
        if (isInitial) {
          newJobRequests.value = response.data!;
          allJobsCount.value = newJobRequests.length;
        } else {
          if (!listEquals(newJobRequests.value, response.data!)) {
            newJobRequests.value = response.data!;
            allJobsCount.value = newJobRequests.length;
          }
        }
        getPendingJobRequests();
        getCompletedCount();
      } else {
        hasError.value = true;
        errorMessage.value = response.message!;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAcceptedJobRequests() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = "";
    try {
      final response = await JobListService.getAcceptedJobRequests();
      if (response.status && response.data != null) {
        acceptedJobRequests.value = response.data!;
      } else {
        hasError.value = true;
        errorMessage.value = response.message!;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
    } finally {
      isLoading.value = false;
    }
  }

  void getPendingJobRequests() {
    pendingJobRequests.clear();
    for (var job in newJobRequests.value) {
      if (job.status! == "pending") {
        pendingJobRequests.add(job);
      }
    }
    pendingCount.value = pendingJobRequests.length;
  }

  void getCompletedCount() {
    completedCount.value = 0;
    for (var job in newJobRequests.value) {
      if (job.status! == "completed") {
        completedCount.value++;
      }
    }
  }

  Future<bool> acceptJob(int jobId) async {
    isLoading.value = true;
    isAcceptClicked.value = true;
    hasError.value = false;
    errorMessage.value = "";
    try {
      final response = await JobListService.acceptJobRequest(jobId);
      log("status ${response.status}");
      if (response.status) {
        await getNewJobRequests();
        await getAcceptedJobRequests();
        return true;
      }
      return false;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      return false;
    } finally {
      isLoading.value = false;
      isAcceptClicked.value = false;
    }
  }

  Future<bool> rejectJob(int jobId) async {
    isLoading.value = true;
    isRejectClicked.value = true;
    hasError.value = false;
    errorMessage.value = "";
    try {
      final response = await JobListService.rejectJobRequest(jobId);
      if (response.status) {
        await getNewJobRequests();
        return true;
      }
      return false;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      return false;
    } finally {
      isLoading.value = false;
      isRejectClicked.value = false;
    }
  }

  Future<void> toggleActivity(bool activity) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = "";
    try {
      final response = await JobListService.toggleActivity(activity);
      if (response.status && response.data != null) {
        isOnline.value = response.data!;
        await SharedPrefs.setBool("is_online", isOnline.value);
      } else {
        hasError.value = true;
        errorMessage.value = response.message!;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
    } finally {
      isLoading.value = false;
    }
  }
}
