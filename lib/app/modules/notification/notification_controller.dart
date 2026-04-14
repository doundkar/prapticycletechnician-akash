import 'dart:async';

import 'package:bicycle_app_technician/app/model/notification_model.dart';
import 'package:bicycle_app_technician/app/modules/notification/notification_service.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var hasNew = false.obs;

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void getData() async {
    await getNotification();
    timer = Timer.periodic(Duration(seconds: 10), (timer){
      getNotification(isInitial: false);
    });
  }

  void getHasNew(){
    for(var n in notifications.value){
      if(n.isRead==false){
        hasNew.value = true;
        break;
      }
    }
  }

  Future<void> getNotification({bool isInitial = true}) async {
    if(isInitial){
      isLoading.value = true;
    }
    hasError.value = false;
    errorMessage.value = "";
    try {
      final response = await NotificationService.getNotifications();
      if (response.status && response.data != null) {
        notifications.clear();
        notifications.value = response.data!;
        getHasNew();
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

  Future<void> clearNotification() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = "";
    try {
      final response = await NotificationService.clearNotificatoins();
      if (response) {
        notifications.clear();
      } else {
        hasError.value = true;
        errorMessage.value = "Notifications couldn't be cleared";
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> readNotification() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = "";
    try {
      final response = await NotificationService.readNotificatoins();
      if (response) {
        hasNew.value = false;
      } else {
        hasError.value = true;
        errorMessage.value = "Couldn't read notifications";
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Some error $e occurred";
    } finally {
      isLoading.value = false;
    }
  }
}
