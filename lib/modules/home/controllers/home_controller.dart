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
    with StateMixin<Lawyer>, WidgetsBindingObserver {
  final ApiRepository _apiRepository = Get.find();
  final showPerformanceOverlay = false.obs;
  int currentIndex = 0;
  final isLoading = false.obs;
  final rxUser = Rxn<Lawyer?>();
  Lawyer? get user => rxUser.value;
  set user(value) => rxUser.value = value;

  Widget getView(int index) {
    switch (index) {
      case 0:
        return const PrimeView();
<<<<<<< HEAD
      case 1:
        return const OrderTrackingPage();
=======
>>>>>>> 68bcbe4b2c4ebe07601124762adfe571c6bce041

      default:
        return const Center(child: Text('Something went wrong'));
    }
  }

  changeNavIndex(int index) {
    currentIndex = index;
    update();
  }

  Future<void> setupApp() async {
    isLoading.value = true;
    try {
      user = await _apiRepository.getUser();

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
