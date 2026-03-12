import 'package:bicycle_app_technician/app/modules/add_parts/controllers/add_parts_controller.dart';
import 'package:bicycle_app_technician/app/modules/job_start/controller/job_progress_controller.dart';
import 'package:get/instance_manager.dart';

class JobProgressBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<JobProgressController>(JobProgressController(), permanent: true);
  }
}