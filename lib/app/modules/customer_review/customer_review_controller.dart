import 'package:bicycle_app_technician/app/modules/customer_review/customer_review_service.dart';
import 'package:get/get.dart';

class CustomerReviewController extends GetxController{

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  Future<bool> postReview(Map<String,dynamic> body) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try{
      final response = await CustomerReviewService.postReview(body);
      if(response.status){
        return true;
      }
      hasError.value = true;
      errorMessage.value = response.message!;
      return false;
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
      return false;
    }
    finally{
      isLoading.value = false;
    }
  }

}