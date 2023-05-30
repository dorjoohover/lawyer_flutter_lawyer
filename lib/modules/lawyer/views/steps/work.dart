import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class WorkView extends StatelessWidget {
  const WorkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerRegisterController());
    return MapsWidget(
      step: 4,
        title: 'Ажлын газрын байршил',
        navigator: () {
          Navigator.push(context, createRoute(const OfficeView()));
        },
        onTap: (p0) {
          controller.lawyer.value?.workLocation?.lat = p0.latitude;
          controller.lawyer.value?.workLocation?.lng = p0.longitude;
        });
  }
}
