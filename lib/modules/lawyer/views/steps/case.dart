import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class CaseView extends StatelessWidget {
  const CaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerRegisterController());
    return Screen(
      step: 7,
        isScroll: false,
        title: 'Шийдсэн хэрэг',
        children: [
          Text(
            'Өөрийн шийдсэн хэргээ оруулна уу.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          space32,
          Obx(() => Column(
                children: controller.decidedCase.map((d) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: small),
                    child: DecidedWidget(
                      date: d.date!,
                      title: d.title!,
                      onDate: (p0) => {d.date = p0, check(controller)},
                      onLink: (p0) => {d.link = p0 ?? '', check(controller)},
                      onTitle: (p0) => {d.title = p0 ?? '', check(controller)},
                      link: d.link!,
                    ),
                  );
                }).toList(),
              )),
          space16,
          InputButton(
              onPressed: () {
                controller.decidedCase.add(Experiences(
                    title: '',
                    date: DateTime.now().millisecondsSinceEpoch,
                    link: ''));
              },
              icon: Icons.abc,
              text: 'Өөр хэрэг нэмэх'),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 120,
          ),
        ],
        child: Obx(() => MainButton(
              onPressed: () {
                Navigator.push(context, createRoute(const AccountView()));
              },
              disabled: !controller.decided.value,
              text: "Үргэлжлүүлэх",
              child: const SizedBox(),
            )));
  }

  void check(LawyerRegisterController controller) {
    if (controller.decidedCase.first.title != '' &&
        controller.decidedCase.first.date != null &&
        controller.decidedCase.first.link != '') {
      controller.decided.value = true;
    } else {
      controller.decided.value = false;
    }
  }
}
