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

class EmergencyController extends GetxController {
  final _apiRepository = Get.find<ApiRepository>();
  final homeController = Get.put(HomeController());
  //addition register

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

  getChannelToken(Order order, BuildContext context, String? profileImg) async {
    try {
      loading.value = true;
      Order getOrder = await _apiRepository.getChannel(order.sId!);
      Navigator.of(context).push(createRoute(Scaffold(
        body: WaitingChannelWidget(
          isLawyer: false,
        ),
      )));
      String channelName = getOrder.channelName!;
      if (getOrder.channelName == 'string') {
        channelName = DateTime.now().millisecondsSinceEpoch.toString();
      }

      Agora token = await _apiRepository.getAgoraToken(channelName, '1');

      if (token.rtcToken != null && channelName != 'string') {
        Order res = await _apiRepository.setChannel(
            'lawyer', order.sId!, channelName!, token.rtcToken!);
        if (res.serviceType == 'onlineEmergency') {
          Get.to(
            () => AudioView(
                order: res,
                isLawyer: false,
                channelName: order.channelName!,
                token: token.rtcToken!,
                name: order.lawyerId!.lastName!,
                uid: 1),
          );
        }
      }

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
