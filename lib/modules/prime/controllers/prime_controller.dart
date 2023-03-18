import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../providers/providers.dart';

class PrimeController extends GetxController {
  final _apiRepository = Get.find<ApiRepository>();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  onClose() {
    super.onClose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }
}
