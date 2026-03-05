import 'package:bicycle_app_technician/app/modules/customer_review/customer_review_controller.dart';
import 'package:get/instance_manager.dart';

class CustomerReviewBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<CustomerReviewController>(()=>CustomerReviewController());
  }
}