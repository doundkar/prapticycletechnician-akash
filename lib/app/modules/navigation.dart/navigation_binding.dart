
import 'package:bicycle_app_technician/app/modules/navigation.dart/navigation_controller.dart';
import 'package:get/instance_manager.dart';

class TechnicianLocationBinding extends Bindings {
  void dependencies() {
    Get.lazyPut<NavigationController>(
      () => NavigationController(),
    );
  }
}
