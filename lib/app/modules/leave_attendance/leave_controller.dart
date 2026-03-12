import 'dart:developer';

import 'package:bicycle_app_technician/app/model/leave_model.dart';
import 'package:bicycle_app_technician/app/model/report_model.dart';
import 'package:bicycle_app_technician/app/modules/leave_attendance/leave_service.dart';
import 'package:get/get.dart';

class LeaveController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var isReportLoading = false.obs;
  var isApplyLeaveLoading = false.obs;

  var totalLeaves = 0.obs;
  var leaveBalance = 0.obs;
  var leavesUsed = 0.obs;

  var report = ReportModel().obs;
  RxSet<DateTime> absentDays = RxSet();
  RxSet<DateTime> presentDays = RxSet();
  RxSet<DateTime> weekOffDays = RxSet();

  // RxList<LeaveModel> leaves = RxList();
  RxSet<DateTime> setLeaves = RxSet();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    DateTime now = DateTime.now();
    await getReport(now.year, now.month,isInitial: true);
    await getLeaves(now.year, now.month,isInitial: true);
  }

  void getAbsentAndPresentDays() {
    absentDays.clear();
    presentDays.clear();
    setLeaves.clear();
    weekOffDays.clear();
    for (var day in report.value.days!) {
      List<String> date = day.date!.split("-");
      // log("$date");
      int year = int.parse(date[0]);
      int month = int.parse(date[1]);
      int today = int.parse(date[2]);
      if (day.status != null) {
        if (day.status == "absent") {
          absentDays.add(DateTime(year, month, today));
        }
        if (day.status == "present") {
          presentDays.add(DateTime(year, month, today));
        }
        if(day.status == "weekoff"){
          weekOffDays.add(DateTime(year, month, today));
        }
        if(day.status == "leave"){
          setLeaves.add(DateTime(year,month,today));
        }
      }
    }
    log("anbsent days: ${absentDays.value.toString()}");
    log("present days: ${presentDays.value.toString()}");
  }

  // void getSetLeaves(){
  //   for(var l in leaves.value){
  //     setLeaves.add(DateTime.parse(l.startDate!));
  //   }
  // }

  Future<void> getReport(int year, int month,{bool isInitial = false}) async {
    if(isInitial){
      isLoading.value = true;
    }
    isReportLoading.value = true;
    try {
      final response = await LeaveService.getReport(year, month);
      if (response.status && response.data != null) {
        report.value = response.data!;
        getAbsentAndPresentDays();
        return;
      }
      hasError.value = true;
      errorMessage.value = response.message!;
      log("error from report : ${errorMessage.value}");
      return;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      log("error from report : ${errorMessage.value}");
      return;
    } finally {
      isLoading.value = false;
      isReportLoading.value = false;
    }
  }

  Future<void> getLeaves(int year, int month,{bool isInitial = false}) async {
    if(isInitial){
      isLoading.value = true;
    }
    isReportLoading.value = true;
    try {
      final response = await LeaveService.getLeaves(year, month);
      if (response.status && response.data != null) {
        totalLeaves.value = response.data!["total"];
        leaveBalance.value = response.data!["balance"];
        leavesUsed.value = response.data!["used"];
        return;
      }
      hasError.value = true;
      errorMessage.value = response.message!;
      log("error from leaves : ${errorMessage.value}");
      return;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      log("error from leaves : ${errorMessage.value}");
      return;
    } finally {
      isLoading.value = false;
      isReportLoading.value = false;
    }
  }

  Future<bool> applyLeave(Map<String,dynamic> body) async {
    isApplyLeaveLoading.value = true;
    try {
      final response = await LeaveService.appyLeave(body);
      if (response.status) {
        return response.status;
      }
      hasError.value = true;
      errorMessage.value = response.message!;
      return response.status;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      return false;
    } finally {
      isApplyLeaveLoading.value = false;
    }
  }
}
