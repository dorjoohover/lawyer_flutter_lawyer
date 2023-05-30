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
  final serviceType = "".obs;
  final reason = "".obs;
  final CarouselController carouselController = CarouselController();
  final currentOrder = 0.obs;
  final location = Rxn<LocationDto>(LocationDto(lng: 0, lat: 0));
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

  Future<bool> sendOrder() async {
    try {
      loading.value = true;

      int price = 0;
      int expiredTime = 0;

      if (serviceType.value == 'fulfilledEmergency') {
        final lawyer = await _apiRepository.activeLawyer('any',
            serviceType.value, DateTime.now().millisecondsSinceEpoch, true);
        price = lawyer.first.serviceType!
            .firstWhere((element) => element.type == serviceType.value)
            .price!;
        expiredTime = lawyer.first.serviceType!
            .firstWhere((element) => element.type == serviceType.value)
            .expiredTime!;
        await _apiRepository.createEmergencyOrder(
            DateTime.now().millisecondsSinceEpoch,
            lawyer.first.lawyer!,
            expiredTime,
            price,
            serviceType.value,
            reason.value,
            location.value!);
      } else {
        homeController.createEmergencyOrder(
            "6454309e181b78295d2091b8",
            expiredTime,
            price,
            serviceType.value,
            reason.value,
            location.value!);
      }
      loading.value = false;
      return true;
    } on DioError catch (e) {
      loading.value = false;
      print(e.response);
      Get.snackbar(
        'Error',
        'Something went wrong',
      );
      return false;
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
