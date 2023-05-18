import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

import '../../../providers/providers.dart';

class LawyerRegisterController extends GetxController {
  final _apiRepository = Get.find<ApiRepository>();
  final homeController = Get.put(HomeController());
  final primeController = Get.put(PrimeController());
  // permission
  final personal = false.obs;
  final education = false.obs;
  final license = false.obs;
  final services = false.obs;
  final decided = false.obs;
  final account = false.obs;
  final addition = false.obs;
  //addition register
  final lawyer = Rxn(User(
      workLocation: LocationDto(lat: 0.0, lng: 0.0),
      officeLocation: LocationDto(lat: 0.0, lng: 0.0)));
  // personal
  final lawyerSymbols = "${registerSymbols[0]}${registerSymbols[0]}".obs;
  // education
  final graduate = <Education>[].obs;
  final degree = <Degree>[Degree(title: '')].obs;
  // service
  final service = <String>[''].obs;
  // decided
  final decidedCase = <Experiences>[].obs;

  // addition
  final phones = <String>[].obs;

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

  lawyerRequest() async {
    try {
      loading.value = true;
      lawyer.value?.phone = homeController.user?.phone;
      lawyer.value?.registerNumber =
          lawyerSymbols.value + lawyer.value!.registerNumber!;
      lawyer.value?.userServices = service;
      lawyer.value?.education = graduate;
      lawyer.value?.degree = degree;
      lawyer.value?.experiences = decidedCase;
      lawyer.value?.phoneNumbers = phones;
      final res = await _apiRepository.updateLawyer(lawyer.value!);
      if (res) {
        Get.snackbar(
          'Success',
          'success',
        );
        Get.to(() => const LawyerView());
      } else {
        Get.snackbar(
          'error',
          'error',
        );
        Get.to(() => const PrimeView());
      }
      loading.value = false;
    } on DioError catch (e) {
      loading.value = false;
      Get.snackbar(
        'Error',
        e.response?.toString() ?? 'Something went wrong',
      );
    }
  }

  start() async {
    try {
      loading.value = true;
      if (homeController.user?.degree != null &&
          homeController.user!.degree!.isNotEmpty) {
        degree.value = homeController.user!.degree!;
      } else {
        degree.value = [Degree(title: '')];
      }
      if (homeController.user?.education != null &&
          homeController.user!.education!.isNotEmpty) {
        graduate.value = homeController.user!.education!;
      } else {
        graduate.value = [Education(title: '')];
      }
      if (homeController.user?.experiences != null &&
          homeController.user!.experiences!.isNotEmpty) {
        decidedCase.value = homeController.user!.experiences!;
      } else {
        decidedCase.value = [
          Experiences(title: '', date: DateTime.now().microsecond, link: '')
        ];
      }

      if (homeController.user?.account == null) {
        lawyer.value?.account =
            Account(bank: '', username: '', accountNumber: 0);
      }

      if (homeController.user?.phoneNumbers != null &&
          homeController.user!.phoneNumbers!.isNotEmpty) {
        phones.value = homeController.user!.phoneNumbers!;
      } else {
        phones.value = [''];
      }
      if (homeController.user?.userServices != null &&
          homeController.user!.userServices!.isNotEmpty) {
        service.value = homeController.user!.userServices!;
      } else {
        service.value = [primeController.services[0].sId ?? ''];
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

  @override
  onClose() {
    super.onClose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }
}
