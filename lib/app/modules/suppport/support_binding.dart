import 'package:bicycle_app_technician/app/modules/suppport/support_controller.dart';
import 'package:get/instance_manager.dart';

class SupportBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SupportController>(()=>SupportController());
  }
}