import 'package:dio/dio.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/providers/api_repository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/index.dart';
import '../../splash/splash.dart' show SplashController;

class AuthController extends GetxController {
  final ApiRepository apiRepository;
  AuthController({required this.apiRepository});
  final prefs = Get.find<SharedPreferences>();
  final loading = false.obs;
  final isVisible = true.obs;
  get isLoading => loading.value;
  set isLoading(value) => loading.value = value;
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final phone = "".obs;
  final loginPhoneController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final pageController = PageController();
  final currentPage = 0.obs;
  showPassword() async {
    isVisible.value = !isVisible.value;
    await Future.delayed(const Duration(milliseconds: 500));
    isVisible.value = !isVisible.value;
  }

  @override
  onInit() {
    super.onInit();
    loginPhoneController.addListener(_loginEmailListener);
  }

  _loginEmailListener() {
    if (loginPhoneController.text.length == 8) {
      Get.focusScope?.unfocus();
    }
  }

  login(BuildContext context) async {
    AppFocus.unfocus(context);

    try {
      isLoading = true;
      final res = await apiRepository.login(
        phone.value,
        loginPasswordController.text,
      );
      _saveTokens(res);
      isLoading = false;
    } on DioError catch (e) {
      print(e);
      // print(e.response?.data['message'].toString());
      Get.snackbar(
        e.response?.statusMessage ?? 'Login Failed',
        e.response?.data['message'] ?? 'Something went wrong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      loginPasswordController.clear();
      isLoading = false;
    }
  }

  // forgetPassword(BuildContext context) async {
  //   AppFocus.unfocus(context);
  // }

  Future<void> logout() async {
    final prefs = Get.find<SharedPreferences>();
    await prefs.remove(StorageKeys.token.name);
    Get.find<SplashController>().token.value = null;
  }

  @override
  void dispose() {
    loginPasswordController.removeListener(_loginEmailListener);
    loginPhoneController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  _saveTokens(LoginResponse res) async {
    final prefs = Get.find<SharedPreferences>();
    await prefs.setString(StorageKeys.token.name, res.token);
    Get.find<SplashController>().token.value = res.token;
  }
}
