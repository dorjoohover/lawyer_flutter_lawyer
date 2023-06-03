import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/auth/auth.dart';
import 'package:frontend/modules/lawyer/controllers/controllers.dart';
import 'package:frontend/modules/lawyer/lawyer.dart';
import 'package:frontend/shared/constants/index.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class EducationView extends StatelessWidget {
  const EducationView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerRegisterController());
    List<String> degrees = ['0', 'Бакалавр', 'Магистр', 'Докторант'];
    return Screen(
        step: 2,
        isScroll: false,
        title: 'Боловсрол',
        children: Column(
          children: [
            Text(
              'Та эрдмийн зэргийн талаарх мэдээллээ оруулна уу.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            space32,
            Column(
                children: degrees.map((e) {
              final i = degrees.indexOf(e);
              if (e != '0') {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: small),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.degree.value = e,
                        child: Container(
                          padding: const EdgeInsets.all(origin),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: primary, width: 2),
                              ),
                              child: Obx(
                                () => Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: controller.degree.value == e
                                          ? primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: primary, width: 2)),
                                ),
                              )),
                        ),
                      ),
                      space8,
                      Flexible(
                        child: GestureDetector(
                          onTap: () => controller.degree.value = e,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: origin),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              e,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              return const SizedBox();
            }).toList()),
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
        ),
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
    if (controller.degree.value != '' && controller.graduate[0].title != '') {
      controller.education.value = true;
    } else {
      controller.education.value = false;
    }
  }
}
