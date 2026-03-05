import 'package:bicycle_app_technician/app/modules/leave_attendance/leave_controller.dart';
import 'package:get/instance_manager.dart';

class LeaveBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<LeaveController>(() => LeaveController());
  }
}