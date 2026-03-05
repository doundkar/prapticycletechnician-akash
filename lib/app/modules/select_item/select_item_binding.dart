import 'package:bicycle_app_technician/app/modules/select_item/select_item_controller.dart';
import 'package:get/instance_manager.dart';

class SelectItemBinding extends Bindings {
     void dependencies(){
    Get.lazyPut<SelectItemController>(()=>SelectItemController());
  }
}