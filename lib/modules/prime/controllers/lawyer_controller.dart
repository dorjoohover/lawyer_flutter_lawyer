import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

import '../../../providers/providers.dart';

class LawyerController extends GetxController {
  final _apiRepository = Get.find<ApiRepository>();
  final homeController = Get.put(HomeController());
  //addition register
  final bio = "".obs;
  final experience = "".obs;
  final selectedServices = <String>[].obs;
  final selectedDate = DateTime.now().obs;
  final selectedDay = <AvailableTime>[].obs;
  final selectedTime = <SelectedTime>[].obs;
  final serviceTypeTimes = <ServiceTypeTime>[].obs;
  final selectedAvailableDays = Rxn<AvailableDay>(AvailableDay(
      date: '${DateTime.now().year}-${DateTime.now().month}',
      serviceId: "",
      serviceTypeTime: []));

  final loading = false.obs;

  @override
  void onInit() async {
    await start();
    super.onInit();
  }

  addAvailableDays() async {
    try {
      loading.value = true;
      serviceTypeTimes
          .add(ServiceTypeTime(serviceType: "online", time: selectedDay));
      selectedAvailableDays.value?.date =
          '${selectedDate.value.year}-${selectedDate.value.month}';
      selectedAvailableDays.value?.serviceTypeTime = serviceTypeTimes;
      final res =
          await _apiRepository.addAvailableDays(selectedAvailableDays.value!);
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
        'Something went wrong',
      );
    }
  }

  sendAddition() async {
    try {
      loading.value = true;
      serviceTypeTimes
          .add(ServiceTypeTime(serviceType: "online", time: selectedDay));
      selectedAvailableDays.value?.date =
          '${selectedDate.value.year}-${selectedDate.value.month}';
      selectedAvailableDays.value?.serviceTypeTime = serviceTypeTimes;

      final res = await _apiRepository.updateLawyer(int.parse(experience.value),
          bio.value, "", selectedAvailableDays.value!);
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

  start() async {
    try {
      loading.value = true;

      // await homeController.setupApp();
      // selectedAvailableDays.value = homeController.user?.availableDays ?? [];
      // selectedDate.value = DateTime.parse(
      //     homeController.user?.availableDays?.first.date ??
      // DateTime.now().toString());
      // selectedDay.value = homeController
      //         .user?.availableDays?.first.serviceTypeTime?.first.time ??
      //     [];
      // homeController.user?.availableDays?.first.serviceTypeTime?.first.time
      //     ?.map((e) => selectedTime.value =
      //         (e.time?.map((t) => SelectedTime(day: e.day, time: t)).toList() ??
      //             []));
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
