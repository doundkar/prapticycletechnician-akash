import 'package:bicycle_app_technician/app/modules/profile/profile_controller.dart';
import 'package:get/instance_manager.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}