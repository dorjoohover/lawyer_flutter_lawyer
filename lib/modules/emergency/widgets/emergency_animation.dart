import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

class EmergencyAnimationContainer extends StatelessWidget {
  const EmergencyAnimationContainer(
      {super.key,
      required this.child,
      this.opacity = -1,
      this.duration = const Duration(seconds: 1)});

  final Duration duration;
  final double? opacity;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrimeController());
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
