import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class OfficeView extends StatelessWidget {
  const OfficeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerRegisterController());
    return MapsWidget(
        title: 'Оффисын байршил',
        navigator: () {
          Navigator.push(context, createRoute(const RegisterServiceView()));
        },
        onTap: (p0) {
          controller.lawyer.value?.officeLocation?.lat = p0.latitude;
          controller.lawyer.value?.officeLocation?.lng = p0.longitude;
        });
  }
}
