import 'package:bicycle_app_technician/app/model/component_items_model.dart';
import 'package:bicycle_app_technician/app/model/components_model.dart';
import 'package:bicycle_app_technician/app/modules/add_parts/service/add_parts_service.dart';
import 'package:get/get.dart';

class AddPartsController extends GetxController{

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  RxList<ComponentsModel> components = <ComponentsModel>[].obs;
  RxList<ComponentItemsModel> componentItems = <ComponentItemsModel>[].obs;

  RxList<ComponentItemsModel> extraItems = <ComponentItemsModel>[].obs;

  @override
  void onInit(){
    super.onInit();
    loadInit();
  }

  void loadInit() async {
    await getComponents();
  }

  Future<void> getComponents() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try{
      final response = await  AddPartsService.getComponents();
      if(response.status){
        components.addAll(response.data!);
      }
      else{
        hasError.value = true;
        errorMessage.value = response.message!;
      }
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Erro $e occurred";
    }
    finally{
      isLoading.value = false;
    }

  }

  Future<void> getComponentItems(int categoryId) async {

    componentItems.clear();

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try{
      final response = await  AddPartsService.getComponentItems(categoryId);
      if(response.status){
        componentItems.addAll(response.data!);
      }
      else{
        hasError.value = true;
        errorMessage.value = response.message!;
      }
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Erro $e occurred";
    }
    finally{
      isLoading.value = false;
    }

  }

  Future<void> loadMoreComponentItems(int categoryId,int page) async {

    // componentItems.clear();

    
    hasError.value = false;
    errorMessage.value = '';

    try{
      final response = await  AddPartsService.loadMoreComponentItems(categoryId,page);
      if(response.status){
        componentItems.addAll(response.data!);
      }
      else{
        hasError.value = true;
        errorMessage.value = response.message!;
      }
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Erro $e occurred";
    }
    finally{
      isLoading.value = false;
    }

  }

  Future<bool> sendApproval(int jobId) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try{

      List<Map<String,dynamic>> items = [];
      for(var item in extraItems){
        items.add({"id":item.id!,"qty":item.qty});
      }

      final response = await  AddPartsService.sendApprovalNotification(jobId,items);
      if(response.status){
        return true;
      }
      else{
        hasError.value = true;
        errorMessage.value = response.message!;
        return false;
      }
    }
    catch(e){
      hasError.value = true;
      errorMessage.value = "Erro $e occurred";
      return false;
    }
    finally{
      isLoading.value = false;
    }

  }

}