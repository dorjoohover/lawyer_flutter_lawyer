import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

class PrimeAnimationContainer extends StatelessWidget {
  const PrimeAnimationContainer(
      {super.key,
      required this.child,
      this.opacity = -1,
      this.duration = const Duration(milliseconds: 375)});

  final Duration duration;
  final double? opacity;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerController());
    return Obx(() => AnimatedPadding(
          padding: EdgeInsets.symmetric(
            vertical: controller.fade.value ? 32 : 0,
          ),
          duration: duration,
          child: AnimatedOpacity(
            opacity: opacity == -1
                ? controller.fade.value
                    ? 0
                    : 1
                : opacity!,
            duration: duration,
            child: child,
          ),
        ));
  }
}
