import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

class LawyerAnimationContainer extends StatelessWidget {
  const LawyerAnimationContainer(
      {super.key,
      required this.child,
      this.duration = const Duration(seconds: 1)});

  final Duration duration;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerController());
    return Obx(() => AnimatedOpacity(
          opacity: controller.fade.value ? 0 : 1,
          duration: duration,
          child: child,
        ));
  }
}
