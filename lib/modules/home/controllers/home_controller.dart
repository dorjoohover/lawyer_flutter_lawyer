import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/prime/views/maps.dart';
import 'package:frontend/providers/api_repository.dart';
import 'package:frontend/shared/constants/enums.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules.dart';

class HomeController extends GetxController
    with StateMixin<User>, WidgetsBindingObserver {
  final ApiRepository _apiRepository = Get.find();
  final showPerformanceOverlay = false.obs;
  final currentIndex = 0.obs;
  final isLoading = false.obs;
  final rxUser = Rxn<User?>();
  User? get user => rxUser.value;
  set user(value) => rxUser.value = value;

  Widget getView(int index) {
    switch (index) {
      case 0:
        return const PrimeView();
      case 1:
        return const OrderTrackingPage();
      case 2:
        return user?.userType == 'lawyer'
            ? const LawyerView()
          : const SizedBox();

      default:
        return const Center(child: Text('Something went wrong'));
    }
  }

  changeNavIndex(int index) {
    currentIndex.value = index;
    update();
  }

  Future<void> setupApp() async {
    isLoading.value = true;
    try {
      user = await _apiRepository.getUser();

      if (user?.userType == 'lawyer') {
        changeNavIndex(2);
      }
      change(user, status: RxStatus.success());

      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      Get.find<SharedPreferences>().remove(StorageKeys.token.name);
      update();
    }
  }

  @override
  void onInit() async {
    await setupApp();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  onReady() {
    super.onReady();
  }
}
