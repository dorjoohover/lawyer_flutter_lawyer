import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class AdditionWidget extends StatelessWidget {
  const AdditionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerRegisterController());
    return Screen(
        step: 9,
        title: 'Нэмэлт мэдээлэл',
        children: Column(
          children: [
            space32,
            Text(
              'Өөрийн танилцуулгаа оруулна уу.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            space32,
            Obx(
              () => Column(
                  children: controller.phones.map((e) {
                final i = controller.phones.indexOf(e);
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: small),
                  child: Input(
                      onChange: (p0) {
                        controller.phones[i] = p0;
                        check(controller);
                      },
                      textInputType: TextInputType.number,
                      labelText: 'Утасны дугаар'),
                );
              }).toList()),
            ),
            space16,
            InputButton(
                onPressed: () {
                  controller.phones.add('');
                },
                icon: Icons.abc,
                text: 'Өөр утасны дугаар нэмэх'),
            space32,
            Input(
                onChange: (p0) {
                  controller.lawyer.value?.email = p0;
                  check(controller);
                },
                labelText: 'Цахим шуудан'),
            space32,
          ],
        ),
        child: Obx(() => MainButton(
              onPressed: () {
                controller.lawyerRequest();
              },
              disabled: !controller.addition.value,
              text: "Илгээх",
              child: const SizedBox(),
            )));
  }

  void check(LawyerRegisterController controller) {
    if (controller.lawyer.value?.email != '' && controller.phones.first != '') {
      controller.addition.value = true;
    } else {
      controller.addition.value = false;
    }
  }
}
