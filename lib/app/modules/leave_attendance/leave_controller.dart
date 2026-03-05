import 'package:bicycle_app_technician/app/model/report_model.dart';
import 'package:bicycle_app_technician/app/modules/leave_attendance/leave_service.dart';
import 'package:get/get.dart';

class LeaveController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var report = ReportModel().obs;
  RxSet<DateTime> absentDays = RxSet();
  RxSet<DateTime> presentDays = RxSet();

  @override
  void onInit(){
    super.onInit();
    getData();
    
  }

  Future<void> getData() async {
    DateTime now = DateTime.now();
    await getReport(now.year,now.month);
  }

  void getAbsentAndPresentDays(){
    for(var day in report.value.days!){
      List<String> date = day.date!.split("-");
        int year = int.parse(date[0]);
        int month = int.parse(date[1]);
        int today = int.parse(date[2]);
      if(day.status=="absent"){
        absentDays.add(DateTime(year,month,today));
      }
      if(day.status == "present"){
        presentDays.add(DateTime(year,month,today));
      }
    }
  }

  Future<void> getReport(int year, int month) async {
    isLoading.value = true;
    try{
      final response = await LeaveService.getReport(year, month);
      if(response.status && response.data!=null){
        report.value = response.data!;
        getAbsentAndPresentDays();
        return;
      }
      hasError.value = true;
      errorMessage.value = response.message!;
      return;
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Error $e occurred";
      return;
    }
    finally{
      isLoading.value = false;
    }
  }

}