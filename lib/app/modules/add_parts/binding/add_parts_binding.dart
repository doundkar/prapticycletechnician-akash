import 'package:bicycle_app_technician/app/modules/add_parts/controllers/add_parts_controller.dart';
import 'package:get/instance_manager.dart';

class AddPartsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddPartsController>(AddPartsController(), permanent: true);
  }
}