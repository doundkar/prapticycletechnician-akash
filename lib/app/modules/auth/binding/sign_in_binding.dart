import 'package:bicycle_app_technician/app/modules/auth/controller/sign_in_controller.dart';
import 'package:get/instance_manager.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}
