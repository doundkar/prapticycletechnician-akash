import 'package:bicycle_app_technician/app/model/salary_slip_model.dart';
import 'package:bicycle_app_technician/app/modules/salary_slip/salary_slip_service.dart';
import 'package:get/state_manager.dart';

class SalarySlipController extends GetxController{

  var isSalaryLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var isLoading = false.obs;

  Rxn<SalarySlipModel> salarySlip = Rxn<SalarySlipModel>();

  @override
  void onInit(){
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    await getSalarySlip(DateTime.now().month,DateTime.now().year,isInitial: true);
  }

  Future<void> getSalarySlip(int month,int year,{bool isInitial = false}) async {
    if(isInitial){
      isLoading.value = true;
    }
    isSalaryLoading.value = true;
    hasError.value = false;
    errorMessage.value = "";
    try {
      final response = await SalarySlipService.getSalary(year,month);
      if (response.status && response.data != null) {
       salarySlip.value = response.data!;
      } else {
        hasError.value = true;
        errorMessage.value = response.message!;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
    } finally {
      isSalaryLoading.value = false;
      isLoading.value = false;
    }
  }

}