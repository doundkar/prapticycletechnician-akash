import 'package:bicycle_app_technician/app/modules/salary_slip/salary_slip_controller.dart';
import 'package:get/instance_manager.dart';

class SalarySlipBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SalarySlipController>(()=>SalarySlipController());
  }
}