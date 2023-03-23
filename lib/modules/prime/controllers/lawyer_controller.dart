import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

import '../../../providers/providers.dart';

class LawyerController extends GetxController {
  final _apiRepository = Get.find<ApiRepository>();

  //addition register
  final bio = "".obs;
  final experience = "".obs;
  final selectedServices = <String>[].obs;
  final selectedAvailableDays = <AvailableDay>[].obs;
  final selectedDate = DateTime.now().obs;
  final selectedDay = <AvailableTime>[].obs;
  final selectedTime = <SelectedTime>[].obs;

  final subServices = <SubService>[].obs;
  final lawyers = <Lawyer>[].obs;
  final loading = false.obs;
  final selectedService = "".obs;
  final selectedServiceType = "".obs;
  final orders = <Order>[].obs;
  final audioController =
      Get.put<AudioController>(AudioController(), permanent: true);
  final videoController =
      Get.put<VideoController>(VideoController(), permanent: true);
  @override
  void onInit() async {
    await start();
    super.onInit();
  }

  sendAddition() async {
    try {
      loading.value = true;
      List<ServiceTypeTime> serviceTypeTimes = [];
      serviceTypeTimes
          .add(ServiceTypeTime(serviceType: "online", time: selectedDay));
      selectedAvailableDays.first.date = selectedDate.value.toString();
      selectedAvailableDays.first.serviceTypeTime = serviceTypeTimes;

      final res = await _apiRepository.updateLawyer(
          int.parse(experience.value), bio.value, "", selectedAvailableDays);
      if (res) {
        Get.snackbar(
          'Success',
          'success',
        );
        Get.to(() => PrimeView());
      } else {
        Get.snackbar(
          'error',
          'error',
        );
        Get.to(() => PrimeView());
      }
      loading.value = false;
    } on DioError catch (e) {
      loading.value = false;
      Get.snackbar(
        'Error',
        e.response?.data ?? 'Something went wrong',
      );
    }
  }

  getChannelToken(String channelName, String type) async {
    try {
      loading.value = true;
      // final res = await _apiRepository.getAgoraToken(
      //     DateTime.parse(channelName).millisecondsSinceEpoch.toString(), '1');
      if (type == 'online') {
        audioController.channelId.value =
            DateTime.parse(channelName).millisecondsSinceEpoch.toString();

        audioController.channelToken.value =
            "006a941d13a5641456b95014aa4fc703f70IAB24n+WHua5t7pquMygdN3qH6n7MuoNQxpF1FNEgTNe6PhB+WG379yDIgDHfjwFt8kYZAQAAQBfmxdkAgBfmxdkAwBfmxdkBABfmxdk";
      }
      if (type == 'fulfilled') {
        // videoController.channelId.value =
        //     DateTime.parse(channelName).millisecondsSinceEpoch.toString();
        // videoController.channelToken.value =
        //     "006a941d13a5641456b95014aa4fc703f70IAB24n+WHua5t7pquMygdN3qH6n7MuoNQxpF1FNEgTNe6PhB+WG379yDIgDHfjwFt8kYZAQAAQBfmxdkAgBfmxdkAwBfmxdkBABfmxdk";

        // await videoController.initEngine();
        // await videoController.joinChannel();
        // Get.to(() => VideoView());
      }

      loading.value = false;
    } on DioError catch (e) {
      loading.value = false;
      Get.snackbar(
        'Error',
        e.response?.data ?? 'Something went wrong',
      );
    }
  }

  getOrderList() async {
    try {
      loading.value = true;
      final res = await _apiRepository.orderList();
      print(res);
      orders.value = res;
      Get.to(() => OrdersView(title: 'Захиалгууд'));
      loading.value = false;
    } on DioError catch (e) {
      loading.value = false;
      Get.snackbar(
        'Error',
        e.response?.data ?? 'Something went wrong',
      );
    }
  }

  getSuggestLawyer(String title, String description, String sId) async {
    try {
      loading.value = true;
      selectedService.value = sId;
      final lRes = await _apiRepository.suggestedLawyersByCategory(sId);
      lawyers.value = lRes;
      Get.to(() => SubServiceView(
            title: title,
            description: description,
          ));
      loading.value = false;
    } on DioError catch (e) {
      loading.value = false;
      Get.snackbar(
        'Error',
        e.response?.data ?? 'Something went wrong',
      );
    }
  }

  getSubServices(String id, String title) async {
    try {
      loading.value = true;
      final res = await _apiRepository.subServiceList(id);
      subServices.value = res;

      Get.to(() => ServicesView(
            title: title,
          ));
      loading.value = false;
    } on DioError catch (e) {
      loading.value = false;
      Get.snackbar(
        'Error',
        e.response?.data ?? 'Something went wrong',
      );
    }
  }

  start() async {
    try {
      loading.value = true;

      final lRes = await _apiRepository.suggestedLawyers();
      lawyers.value = lRes;
      loading.value = false;
    } on DioError catch (e) {
      loading.value = false;
      Get.snackbar(
        'Error',
        e.response?.data ?? 'Something went wrong',
      );
    }
  }

  @override
  onClose() {
    super.onClose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }
}
