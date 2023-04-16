import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

import '../../../providers/providers.dart';

class LawyerController extends GetxController {
  final _apiRepository = Get.find<ApiRepository>();
  final homeController = Get.put(HomeController());
  //addition register
  final bio = "".obs;
  final experience = "".obs;
  final selectedService = "".obs;
  final selectedSubServices = <String>[].obs;
  final selectedDate = DateTime.now().obs;
  final selectedDay = <AvailableTime>[].obs;
  final selectedTime = <SelectedTime>[].obs;
  final serviceTypeTimes = <ServiceTypeTime>[].obs;
  final CarouselController carouselController = CarouselController();
  final currentOrder = 0.obs;
  final selectedAvailableDays =
      Rxn<AvailableDay>(AvailableDay(serviceId: "", serviceTypeTime: []));
  final fade = true.obs;
  final loading = false.obs;

  @override
  void onInit() async {
    Future.delayed(const Duration(milliseconds: 300), () {
      fade.value = false;
    });
    await start();
    super.onInit();
  }

  getChannelToken(
      String orderId,
      String channelName,
      String type,
      BuildContext context,
      bool isLawyer,
      String name,
      String? profileImg) async {
    try {
      loading.value = true;
      if (type == 'online') {
        Navigator.of(context).push(createRoute(Scaffold(
          body: WaitingChannelWidget(
            isLawyer: isLawyer,
          ),
        )));
      }
      if (channelName == 'string') {
        channelName = DateTime.now().millisecondsSinceEpoch.toString();
      }

      Agora token =
          await _apiRepository.getAgoraToken(channelName, isLawyer ? '2' : '1');

      if (token.rtcToken != null) {
        bool res = await _apiRepository.setChannel(isLawyer ? 'lawyer' : 'user',
            orderId, channelName, token.rtcToken!);
        if (res) {
          if (type == 'online') {
            Navigator.of(context).push(createRoute(Scaffold(
              body: AudioView(
                  isLawyer: isLawyer,
                  channelName: channelName,
                  token: token.rtcToken!,
                  name: name,
                  uid: isLawyer ? 2 : 1),
            )));
          }
          if (type == 'fulfilled') {
            print(token.rtcToken!);
            Navigator.of(context).push(createRoute(Scaffold(
              body: VideoView(
                  isLawyer: isLawyer,
                  channelName: channelName,
                  token: token.rtcToken!,
                  name: name,
                  uid: isLawyer ? 2 : 1),
            )));
          }
        }
      }

      // videoController.channelId.value =
      //     DateTime.parse(channelName).millisecondsSinceEpoch.toString();
      // videoController.channelToken.value =
      //     "006a941d13a5641456b95014aa4fc703f70IAB24n+WHua5t7pquMygdN3qH6n7MuoNQxpF1FNEgTNe6PhB+WG379yDIgDHfjwFt8kYZAQAAQBfmxdkAgBfmxdkAwBfmxdkBABfmxdk";

      // await videoController.initEngine();
      // await videoController.joinChannel();
      // Get.to(() => VideoView());

      loading.value = false;
    } on DioError catch (e) {
      loading.value = false;
      print(e.response);
      Get.snackbar(
        'Error',
        'Something went wrong',
      );
    }
  }

  Future<bool> addAvailableDays() async {
    try {
      loading.value = true;

      for (var type in serviceTypeTimes) {
        type.time = selectedDay;
      }
      selectedAvailableDays.value?.serviceId = selectedSubServices.first;
      selectedAvailableDays.value?.serviceTypeTime = serviceTypeTimes;

      final res =
          await _apiRepository.addAvailableDays(selectedAvailableDays.value!);
      bio.value = "";
      experience.value = "";
      selectedService.value = "";
      selectedSubServices.value = <String>[];
      selectedDate.value = DateTime.now();
      selectedDay.value = <AvailableTime>[];
      selectedTime.value = <SelectedTime>[];
      serviceTypeTimes.value = <ServiceTypeTime>[];
      selectedAvailableDays.value =
          AvailableDay(serviceId: "", serviceTypeTime: []);
      loading.value = false;
      if (res) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      loading.value = false;
      Get.snackbar(
        'Error',
        'Something went wrong',
      );
      return false;
    }
  }

  sendAddition() async {
    try {
      loading.value = true;
      serviceTypeTimes.map((type) => type.time = selectedDay);
      selectedAvailableDays.value?.serviceId = selectedService.value;
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
