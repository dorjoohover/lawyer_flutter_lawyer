import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class RegisterServiceView extends StatelessWidget {
  const RegisterServiceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerRegisterController());
    final primeController = Get.put(PrimeController());
    List<String> services =
        primeController.services.map((e) => e.title!).toList();
    return Screen(
      step: 6,
        title: 'Туршлага',
        children: [
          space32,
          Text(
            'Өөрийн туршлагаа оруулна уу.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          space32,
          Obx(() => Column(
                children: controller.service.map((e) {
                  final i = primeController.services
                      .firstWhere((s) => s.sId == e)
                      .title;
                  final index = controller.service.indexOf(e);
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: small),
                    child: DropdownLabel(
                        expanded: true,
                        value: i ?? services[0],
                        onChange: (String? v) {
                          controller.service[index] = primeController.services
                                  .firstWhere((s) => s.title == v)
                                  .sId ??
                              primeController.services.first.sId!;
                        },
                        list: services),
                  );
                }).toList(),
              )),
          space16,
          InputButton(
              onPressed: () {
                controller.service.add(primeController.services.first.sId!);
              },
              icon: Icons.abc,
              text: 'Өөр чиглэл нэмэх'),
          space32,
          Input(
              onChange: (p0) {
                controller.lawyer.value?.experience = int.parse(p0);
                check(controller);
              },
              textInputType: TextInputType.number,
              labelText: 'Ажилласан жил'),
          space32,
        ],
        child: Obx(() => MainButton(
              onPressed: () {
                Navigator.push(context, createRoute(const CaseView()));
              },
              disabled: !controller.services.value,
              text: "Үргэлжлүүлэх",
              child: const SizedBox(),
            )));
  }

  void check(LawyerRegisterController controller) {
    if (controller.service.isNotEmpty &&
        controller.lawyer.value?.experience != null) {
      controller.services.value = true;
    } else {
      controller.services.value = false;
    }
  }
}
