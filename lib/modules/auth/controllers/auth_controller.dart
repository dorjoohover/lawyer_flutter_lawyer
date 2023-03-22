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
  // login
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final phone = "".obs;
  final loginPhoneController = TextEditingController();
  final loginPasswordController = TextEditingController();
  // register
  final lastnameFocus = FocusNode();
  final firstnameFocus = FocusNode();
  final lastname = "".obs;
  final firstname = "".obs;

  final registerSymbol1 = registerSymbols[0].obs;
  final registerSymbol2 = registerSymbols[0].obs;
  final registerNumber = "".obs;

  final registerPhoneFocus = FocusNode();
  final registerPhone = "".obs;

  final registerPasswordFocus = FocusNode();
  final registerPasswordRepeatFocus = FocusNode();
  final registerPasswordIsVisible = false.obs;
  final registerPasswordRepeatIsVisible = false.obs;
  final registerPassword = "".obs;
  final registerPasswordRepeat = "".obs;
  final registerPasswordController = TextEditingController();
  final registerPasswordRepeatController = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

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

  register(BuildContext context) async {
    AppFocus.unfocus(context);
    try {
      loading.value = true;

      final res = await apiRepository.register(registerPhone.value,
          registerPassword.value, firstname.value, lastname.value);
      _saveTokens(res);
      Get.snackbar(
        'Бүртгэл амжилттай',
        " asdf",
        snackPosition: SnackPosition.TOP,
        backgroundColor: success,
        colorText: Colors.white,
      );
      loading.value = false;
    } on DioError catch (e) {
      loading.value = false;
      Get.snackbar(
        e.response?.statusMessage ?? 'Login Failed',
        e.response?.data['message'] ?? 'Something went wrong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
