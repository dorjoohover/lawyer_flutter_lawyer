import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class LicenseView extends StatelessWidget {
  const LicenseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerRegisterController());
    return Screen(
      step: 3,
        title: 'Гэрчилгээний мэдээлэл',
        children: [
          space32,
          Text(
            'Хуульчийн үйл ажиллагаа эрхлэх зөвшөөрлийн үнэмлэхний дугаараа оруулна уу.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          space32,
          Input(
              onChange: (p0) {
                controller.lawyer.value?.licenseNumber = p0;

                check(controller);
              },
              labelText: 'Гэрчилгээний дугаар'),
          space32,
          Input(
              onChange: (p0) {
                controller.lawyer.value?.certificate = p0;
                check(controller);
              },
              labelText: 'Өмгөөлөгчийн үнэмлэхний дугаар'),
          space32,
        ],
        child: Obx(() => MainButton(
              onPressed: () {
                Navigator.push(context, createRoute(const WorkView()));
              },
              disabled: !controller.license.value,
              text: "Үргэлжлүүлэх",
              child: const SizedBox(),
            )));
  }

  void check(LawyerRegisterController controller) {
    if (controller.lawyer.value?.licenseNumber != '' &&
        controller.lawyer.value?.certificate != '') {
      controller.license.value = true;
    } else {
      controller.license.value = false;
    }
  }
}
