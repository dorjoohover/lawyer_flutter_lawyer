import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class PersonalView extends StatelessWidget {
  const PersonalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerRegisterController());
    return Screen(
        title: 'Хувийн мэдээлэл',
        children: [
          space32,
          Text(
            'Өөрийн танилцуулгаа оруулна уу.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          space32,
          Input(
              onChange: (p0) {
                controller.lawyer.value?.firstName = p0;
                checkPersonal(controller);
              },
              labelText: 'Овог'),
          space32,
          Input(
              onChange: (p0) {
                controller.lawyer.value?.lastName = p0;
                checkPersonal(controller);
              },
              labelText: 'Нэр'),
          space32,
          Row(
            children: [
              Expanded(
                  child: Obx(
                () => DropdownLabel(
                    value: controller.lawyerSymbols.value.substring(0, 1),
                    onChange: (String? v) {
                      controller.lawyerSymbols.value =
                          (v ?? registerSymbols[0]) +
                              controller.lawyerSymbols.value.substring(1, 2);
                    },
                    list: registerSymbols),
              )),
              space8,
              Expanded(
                child: Obx(() => DropdownLabel(
                    value: controller.lawyerSymbols.value.substring(1, 2),
                    onChange: (String? v) {
                      controller.lawyerSymbols.value =
                          controller.lawyerSymbols.value.substring(0, 1) +
                              (v ?? registerSymbols[0]);
                    },
                    list: registerSymbols)),
              ),
              space8,
              Expanded(
                flex: 4,
                child: Input(
                    onChange: (p0) {
                      controller.lawyer.value?.registerNumber = p0;
                      checkPersonal(controller);
                    },
                    textInputType: TextInputType.number,
                    labelText: 'Регистрийн дугаар'),
              )
            ],
          )
        ],
        child: Obx(() => MainButton(
              onPressed: () {
                Navigator.push(context, createRoute(const EducationView()));
              },
              disabled: !controller.personal.value,
              text: "Үргэлжлүүлэх",
              child: const SizedBox(),
            )));
  }

  void checkPersonal(LawyerRegisterController controller) {
    if (controller.lawyer.value?.registerNumber?.length == 8 &&
        controller.lawyer.value?.lastName != '' &&
        controller.lawyer.value?.firstName != '') {
      controller.personal.value = true;
    } else {
      controller.personal.value = false;
    }
  }
}
