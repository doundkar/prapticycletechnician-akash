import 'package:bicycle_app_technician/app/modules/auth/controller/sign_in_controller.dart';
import 'package:bicycle_app_technician/app/modules/auth/controller/sign_up_controller.dart';
import 'package:get/instance_manager.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}
