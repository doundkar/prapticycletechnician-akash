import 'package:get/instance_manager.dart';

class JobIdBinding extends Bindings{
   void dependencies(){
    Get.lazyPut<JobIdBinding>(()=>JobIdBinding());
  }
}