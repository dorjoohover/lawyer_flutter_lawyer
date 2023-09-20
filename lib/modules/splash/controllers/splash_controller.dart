import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/routes/routes.dart';
import 'package:frontend/shared/constants/enums.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../shared/index.dart';

class SplashController extends GetxController {
  final token = Rxn<String?>();
  late Worker worker;
  final storage = GetStorage();
  @override
  void onInit() async {
    try {
      final isCurrent = await _isCurrentVersion();
      if (isCurrent == null) {
      } else {
        if (isCurrent) {
          _checkAuthStatus();
        } else {
          _showUpdateDialog();
        }
      }
    } on Exception catch (e) {
      print(e);
      Get.bottomSheet(
        Container(
          height: 100,
          color: Colors.red,
          child: Center(
            child: Text(e.toString()),
          ),
        ),
      );
    }
    super.onInit();
  }

  logout() async {
    await storage.remove(StorageKeys.token.name);
    token.value = null;
  }

  Future<bool?> _isCurrentVersion() async {
    try {
      return true;
    } on DioException catch (e) {
      return null;
    } on Error catch (er) {
      print(er);

      return null;
    }
  }

  /// CHECKING UPDATE VERSION

  _checkAuthStatus() {
    worker = ever<String?>(
      token,
      (tkn) {
        if (tkn != null) {
          Get.toNamed(Routes.home);
        } else {
          Get.toNamed(Routes.auth);
        }
      },
    );
    token.value = storage.read(StorageKeys.token.name);
  }

  // Future<String> getLocalVersion() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();

  //   // return packageInfo.version + '.' + packageInfo.buildNumber;
  //   return packageInfo.version;
  // }

  _showUpdateDialog() {
    // Get.defaultDialog(
    //   barrierDismissible: false,
    //   title: 'Update Available',
    //   middleText: 'Please update the app to continue',
    //   textConfirm: 'Update',
    //   confirmTextColor: Colors.white,
    //   onConfirm: () async {
    //     const url = 'https://testflight.apple.com/join/krCWIXJr';
    //     if (await launchUrl(Uri.parse(url))) {
    //       canLaunchUrl(Uri.parse(url));
    //     } else {
    //       throw 'Cannot load url';
    //     }
    //     // StoreLauncher().open(
    //     //   androidAppBundleId: 'com.eve_flashcards',
    //     //   appStoreId: 'id1520000000',
    //     // );
    //   },
    // );
  }

  @override
  void dispose() {
    worker.dispose();
    super.dispose();
  }
}
