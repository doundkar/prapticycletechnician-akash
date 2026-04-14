import 'package:bicycle_app_technician/app/model/support_model.dart';
import 'package:bicycle_app_technician/app/modules/suppport/support_service.dart';
import 'package:get/state_manager.dart';

class SupportController extends GetxController {

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  Rxn<SupportModel> support = Rxn();

  @override
  void onInit(){
    super.onInit();
  
    getSupportData();
  }

  Future<void> getSupportData() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = "";
    try {
      final response = await SupportService.getSupportData();
      if (response.status && response.data != null) {
        support.value = response.data!;
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