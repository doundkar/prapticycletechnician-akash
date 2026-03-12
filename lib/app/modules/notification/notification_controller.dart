import 'package:bicycle_app_technician/app/modules/notification/notification_service.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController{

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  Future<void> getAcceptedJobRequests() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = "";
    try {
      final response = await NotificationService.getNotifications();
      if (response.status && response.data != null) {
        
      } else {
        hasError.value = true;
        errorMessage.value = response.message!;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
    } finally {
      isLoading.value = false;
    }
  }

}