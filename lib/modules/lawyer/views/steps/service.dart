import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/auth/auth.dart';
import 'package:frontend/modules/lawyer/controllers/controllers.dart';
import 'package:frontend/modules/lawyer/lawyer.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/constants/index.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class RegisterServiceView extends StatefulWidget {
  const RegisterServiceView({super.key});

  @override
  State<RegisterServiceView> createState() => _RegisterServiceViewState();
}

final serviceKey = GlobalKey<FormState>();

class _RegisterServiceViewState extends State<RegisterServiceView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerRegisterController());
    final primeController = Get.put(PrimeController());
    List<String> services =
        primeController.services.map((e) => e.title!).toList();
    return Screen(
        step: 6,
        resize: true,
        title: 'Туршлага',
        children: Form(
          key: serviceKey,
          child: Column(
            children: [
              space32,
              Text(
                'Өөрийн туршлагаа оруулна уу.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              space32,
              Obx(() => Column(
                    children: controller.service.map((e) {
                      int i = controller.service.indexOf(e);
                      final val = controller.serviceNames[i];
                      if (val != '' || controller.service.length == 1) {
                        return Container(
                            margin: const EdgeInsets.symmetric(vertical: small),
                            child: DropdownLabel(
                                expanded: true,
                                value: val != '' ? val : services[0],
                                onChange: (String? v) {
                                  if (controller.serviceNames
                                      .where((p0) => v == p0)
                                      .isEmpty) {
                                    controller.service[i] = primeController
                                        .services
                                        .firstWhere(
                                            (element) => element.title == v!)
                                        .sId!;
                                    controller.serviceNames[i] = v!;
                                  } else {
                                    Get.snackbar('Сонгогдсон байна', "");
                                  }
                                },
                                list: services));
                      } else {
                        return const SizedBox();
                      }
                    }).toList(),
                  )),
              space16,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() => Text(
                      '${controller.service.length} / ${primeController.services.length}'))
                ],
              ),
              space16,
              Obx(() => controller.service.length < 4
                  ? InputButton(
                      onPressed: () {
                        String val = services
                            .toSet()
                            .difference(controller.serviceNames.toSet())
                            .toList()[0];
                        int i = services.indexOf(val);
                        controller.service
                            .add(primeController.services[i].sId!);
                        controller.serviceNames.add(val);
                      },
                      icon: Icons.abc,
                      text: 'Өөр чиглэл нэмэх')
                  : const SizedBox()),
              space16,
              Text(
                'Та ажилласан жилээ оруулна уу.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              space32,
              Input(
                  autoFocus: false,
                  onChange: (p0) {
                    controller.lawyer.value?.experience = int.parse(p0);
                    check(controller);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Та ажилсан жилээ оруулна уу';
                    }

                    return null;
                  },
                  onSubmitted: (p0) {
                    if (serviceKey.currentState!.validate()) {
                      Navigator.push(context, createRoute(const CaseView()));
                    }
                  },
                  textInputType: TextInputType.number,
                  labelText: 'Ажилласан жил'),
              space32,
              space64,
              space64,
            ],
          ),
        ),
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
