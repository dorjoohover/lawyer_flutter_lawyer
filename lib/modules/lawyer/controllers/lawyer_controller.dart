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

  final CarouselController carouselController = CarouselController();
  final currentOrder = 0.obs;
  final availableTime = Rxn(Time(serviceType: []));
  final timeDetail = <TimeDetail>[].obs;
  final selectedDate = DateTime.now().obs;
  final selectedType = <TimeType>[].obs;
  final fade = true.obs;
  final loading = false.obs;

  @override
  void onInit() async {
    Future.delayed(const Duration(milliseconds: 800), () {
      fade.value = false;
    });
    await start();
    super.onInit();
  }

  getOrderDetail(String id) async {
    try {
      Order order = await _apiRepository.getChannel(id);
      return order;
    } on DioError catch (e) {
      Get.snackbar(e.message ?? '', 'error');
    }
  }

  addAvailableDays() async {
    try {
      availableTime.value!.timeDetail = timeDetail;
      availableTime.value!.serviceType = selectedType;

      bool order = await _apiRepository.addAvailableDays(availableTime.value!);
      return order;
    } on DioError catch (e) {
      Get.snackbar(e.message ?? '', 'error');
    }
  }

  getChannelToken(Order order, bool isLawyer, String? profileImg) async {
    try {
      loading.value = true;

      Order getOrder = await _apiRepository.getChannel(order.sId!);

      if (getOrder.lawyerToken == '' || getOrder.userToken == '') {
        getOrder = await _apiRepository
            .setChannel(
          isLawyer,
          order.sId!,
          getOrder.channelName == 'string' || getOrder.channelName == null
              ? DateTime.now().millisecondsSinceEpoch.toString()
              : getOrder.channelName!,
        )
            .then((value) {
          if (getOrder.serviceType == 'onlineEmergency') {
            Get.to(
              () => AudioView(
                  order: getOrder,
                  isLawyer: isLawyer,
                  channelName: order.channelName!,
                  token: isLawyer
                      ? getOrder.lawyerToken ?? ''
                      : getOrder.userToken ?? '',
                  name: isLawyer
                      ? order.clientId!.lastName!
                      : order.lawyerId == null
                          ? 'Lawmax'
                          : order.lawyerId!.lastName!,
                  uid: isLawyer ? 2 : 1),
            );
          }
          if (getOrder.serviceType == 'online') {
            Get.to(
              () => VideoView(
                  order: getOrder,
                  isLawyer: isLawyer,
                  channelName: order.channelName!,
                  token: isLawyer
                      ? getOrder.lawyerToken ?? ''
                      : getOrder.userToken ?? '',
                  name: isLawyer
                      ? order.clientId!.lastName!
                      : order.lawyerId!.lastName!,
                  uid: isLawyer ? 2 : 1),
            );
          }
          return value;
        });
        return;
      }
      if (getOrder.serviceType == 'onlineEmergency') {
        Get.to(
          () => AudioView(
              order: getOrder,
              isLawyer: isLawyer,
              channelName: order.channelName!,
              token: isLawyer
                  ? getOrder.lawyerToken ?? ''
                  : getOrder.userToken ?? '',
              name: isLawyer
                  ? order.clientId!.lastName!
                  : order.lawyerId == null
                      ? 'Lawmax'
                      : order.lawyerId!.lastName!,
              uid: isLawyer ? 2 : 1),
        );
      }
      if (getOrder.serviceType == 'online') {
        Get.to(
          () => VideoView(
              order: getOrder,
              isLawyer: isLawyer,
              channelName: order.channelName!,
              token: isLawyer
                  ? getOrder.lawyerToken ?? ''
                  : getOrder.userToken ?? '',
              name: isLawyer
                  ? order.clientId!.lastName!
                  : order.lawyerId!.lastName!,
              uid: isLawyer ? 2 : 1),
        );
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
