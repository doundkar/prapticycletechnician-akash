import 'package:bicycle_app_technician/app/modules/job_list/job_list_controller.dart';
import 'package:get/get.dart';

class JobListBinding extends Bindings {
  void dependencies(){
    Get.lazyPut<JobListController>(()=>JobListController());
  }
}