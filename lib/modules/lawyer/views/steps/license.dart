import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

final licenseKey = GlobalKey<FormState>();

class LicenseView extends StatelessWidget {
  const LicenseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerRegisterController());
    return Screen(
        step: 3,
        resize: false,
        title: 'Гэрчилгээний мэдээлэл',
        children: Form(
          key: licenseKey,
          child: Column(
            children: [
              space32,
              Text(
                'Хуульчийн үйл ажиллагаа эрхлэх зөвшөөрлийн үнэмлэхний дугаараа оруулна уу.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              space32,
              Input(
                  autoFocus: true,
                  onChange: (p0) {
                    controller.lawyer.value?.licenseNumber = p0;
                    check(controller);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Та гэрчилгээний дугаараа оруулна уу';
                    }
                    return null;
                  },
                  value: controller.lawyer.value?.licenseNumber,
                  labelText: 'Гэрчилгээний дугаар'),
              space32,
              Input(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Та өмгөөлөгчийн үнэмлэхний дугаараа оруулна уу';
                    }
                    return null;
                  },
                  onSubmitted: (p0) {
                    if (licenseKey.currentState!.validate()) {
                      Navigator.push(context, createRoute(const WorkView()));
                    }
                  },
                  value: controller.lawyer.value?.certificate,
                  onChange: (p0) {
                    controller.lawyer.value?.certificate = p0;
                    check(controller);
                  },
                  labelText: 'Өмгөөлөгчийн үнэмлэхний дугаар'),
              space32,
            ],
          ),
        ),
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
