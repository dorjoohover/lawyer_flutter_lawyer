import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class LawyerRegisterServiceType extends StatelessWidget {
  const LawyerRegisterServiceType({super.key});

  Widget build(BuildContext context) {
    final controller = Get.put(LawyerController());
    return Scaffold(
        appBar: PrimeAppBar(
            onTap: () {
              Navigator.pop(context);
            },
            title: "Үйлчилгээний төрөл сонгох"),
        backgroundColor: bg,
        body: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: origin,
                right: origin),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: LawyerServiceWidget(
              onPress: () {
                Navigator.of(context)
                    .push(createRoute(const LawyerAvailableDays()));
              },
              submitText: 'Цааш',
              children: serviceTypes.map((e) {
                return GestureDetector(
                    onTap: () {
                      if (controller.serviceTypeTimes.firstWhereOrNull(
                              (type) => type.serviceType == e['id']) ==
                          null) {
                        controller.serviceTypeTimes
                            .add(ServiceTypeTime(serviceType: e['id']));
                      } else {
                        controller.serviceTypeTimes
                            .removeWhere((type) => type.serviceType == e['id']);
                      }
                    },
                    child: Obx(
                      () => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: origin, horizontal: 12),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(origin),
                            color: controller.serviceTypeTimes.firstWhereOrNull(
                                        (type) =>
                                            type.serviceType == e['id']) !=
                                    null
                                ? primary
                                : Colors.white),
                        child: Text(
                          e['value']!,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: controller.serviceTypeTimes
                                              .firstWhereOrNull((type) =>
                                                  type.serviceType ==
                                                  e['id']) ==
                                          null
                                      ? primary
                                      : Colors.white),
                        ),
                      ),
                    ));
              }).toList(),
            )));
  }
}
