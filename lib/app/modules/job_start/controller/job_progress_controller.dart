import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bicycle_app_technician/app/modules/job_start/service/job_progress_service.dart';
import 'package:get/get.dart';

class JobProgressController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  int timeTakenInMins = 0;

  void calulateTimeTaken() {
    log("total: ${totalSeconds.value}");
    log("remain: ${remainingSeconds.value}");
    timeTakenInMins = ((totalSeconds.value - remainingSeconds.value) / 60).round();
  }

  RxInt remainingSeconds = 0.obs;
  RxInt totalSeconds = 0.obs;
  Timer? timer;

  void setRemainingSeconds(int minutes) {
    remainingSeconds.value = minutes * 60;
  }

  void setTotalSeconds(int minutes) {
    totalSeconds.value = minutes * 60;
  }

  void startTimer() {
    // if (timer != null) return; // prevents multiple timers

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        remainingSeconds.value += 15*60;
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  Future<bool> verifyStartJobOtp(int jobId, int otp) async {
    isLoading.value = true;
    hasError = false.obs;
    errorMessage = ''.obs;
    try {
      final response = await JobProgressService.verifyJobStartOtp(jobId, otp);
      if (response.status) {
        return true;
      }
      return false;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> startJob(int jobId, List<File> photos) async {
    isLoading.value = true;
    hasError = false.obs;
    errorMessage = ''.obs;
    try {
      final response = await JobProgressService.startJob(jobId, photos);

      if (response.status) {
        return true;
      }
      return false;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> completeJob(
    int jobId,
    int otp,
    List<File> images,
    List<dynamic> parts,
  ) async {
    isLoading.value = true;
    hasError = false.obs;
    errorMessage = ''.obs;
    log("parts: $parts");
    try {
      final response = await JobProgressService.completeJob(
        jobId,
        images,
        timeTakenInMins * 60,
        otp,
        parts,
      );
      log("controller: ${response.message}");
      if (response.status) {
        return true;
      }
      return false;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
