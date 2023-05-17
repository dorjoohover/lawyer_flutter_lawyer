import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class EducationView extends GetView<LawyerRegisterController> {
  const EducationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Screen(
        isScroll: false,
        title: 'Боловсрол',
        children: [
          Text(
            'Та эрдмийн зэргийн талаарх мэдээллээ оруулна уу.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          space32,
          Obx(
            () => Column(
                children: controller.degree.map((e) {
              final i = controller.degree.indexOf(e);
              return Container(
                margin: const EdgeInsets.symmetric(vertical: small),
                child: Input(
                    onChange: (p0) {
                      controller.degree[i].title = p0;
                      check(controller);
                    },
                    labelText: 'Эрдмийн зэрэг'),
              );
            }).toList()),
          ),
          space16,
          InputButton(
              onPressed: () {
                controller.degree.add(Degree(title: ''));
              },
              icon: Icons.abc,
              text: 'Өөр төрөл нэмэх'),
          space32,
          Text(
            'Та төгссөн сургуулийн талаарх мэдээллээ оруулна уу.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Obx(
            () => Column(
                children: controller.graduate.map((e) {
              final i = controller.graduate.indexOf(e);
              return Container(
                margin: const EdgeInsets.symmetric(vertical: small),
                child: Input(
                    onChange: (p0) {
                      controller.graduate[i].title = p0;
                      check(controller);
                    },
                    labelText: 'Төгссөн сургууль'),
              );
            }).toList()),
          ),
          space16,
          InputButton(
              onPressed: () {
                controller.graduate.add(Education(title: ''));
              },
              icon: Icons.abc,
              text: 'Өөр төрөл нэмэх'),
          space16,
          space64,
          space64,
        ],
        child: Obx(() => MainButton(
              onPressed: () {
                Navigator.push(context, createRoute(const LicenseView()));
              },
              disabled: !controller.education.value,
              text: "Үргэлжлүүлэх",
              child: const SizedBox(),
            )));
  }

  void check(LawyerRegisterController controller) {
    if (controller.degree[0].title != '' &&
        controller.graduate[0].title != '') {
      controller.education.value = true;
    } else {
      controller.education.value = false;
    }
  }
}
