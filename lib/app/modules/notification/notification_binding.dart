import 'package:bicycle_app_technician/app/modules/notification/notification_controller.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/utils.dart';

class NotificationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(()=>NotificationController());
  }
}