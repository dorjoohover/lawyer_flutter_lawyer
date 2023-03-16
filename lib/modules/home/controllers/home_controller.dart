import 'package:flutter/widgets.dart';
import 'package:frontend/modules/agora/views/audio.dart';
import 'package:frontend/modules/agora/views/video.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final showPerformanceOverlay = false.obs;
  int currentIndex = 0;

  Widget getView(int index) {
    switch (index) {
      case 0:
        return AudioView();
      case 1:
        return VideoView();

      default:
        return const Center(child: Text('Something went wrong'));
    }
  }

  changeNavIndex(int index) {
    currentIndex = index;
    update();
  }

  @override
  void onInit() {
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
