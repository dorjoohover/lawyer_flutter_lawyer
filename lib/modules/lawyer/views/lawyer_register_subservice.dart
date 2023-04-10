import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class LawyerRegisterSubService extends StatelessWidget {
  const LawyerRegisterSubService({super.key, required this.subServices});
  final List<SubService> subServices;
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerController());
    return Scaffold(
        appBar: PrimeAppBar(
            onTap: () {
              Navigator.pop(context);
            },
            title: "Үйлчилгээний дэд төрөл сонгох"),
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
                    .push(createRoute(const LawyerRegisterServiceType()));
              },
              submitText: 'Цааш',
              children: subServices.map((e) {
                return GestureDetector(
                    onTap: () {
                      if (controller.selectedSubServices.firstWhereOrNull(
                              (service) => service == e.sId) ==
                          null) {
                        controller.selectedSubServices.add(e.sId!);
                      } else {
                        controller.selectedSubServices
                            .removeWhere((service) => service == e.sId);
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
                            color: controller.selectedSubServices
                                        .firstWhereOrNull(
                                            (service) => service == e.sId) !=
                                    null
                                ? primary
                                : Colors.white),
                        child: Text(
                          e.title!,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: controller.selectedSubServices
                                              .firstWhereOrNull((service) =>
                                                  service == e.sId) ==
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
