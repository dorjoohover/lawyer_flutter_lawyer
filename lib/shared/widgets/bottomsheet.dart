import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/data/models/available_days.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class OrderBottomSheet extends GetView<PrimeController> {
  const OrderBottomSheet({required this.title, super.key});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(vertical: large, horizontal: origin),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.cancel))
                ],
              ),
              controller.selectedLawyer.value?.userServices?.firstWhereOrNull(
                          (ser) =>
                              ser.serviceId ==
                              controller.selectedService.value) ==
                      null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person),
                                space16,
                                Text(
                                  'Биечлэн уулзах',
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                )
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  controller.selectedServiceType.value =
                                      ServiceTypes(serviceType: 'online');
                                  controller.getSuggestLawyer(
                                      '',
                                      '',
                                      controller.selectedService.value,
                                      context);
                                },
                                icon: const Icon(Icons.arrow_forward_ios)),
                          ]),
                    )
                  : controller.selectedLawyer.value?.userServices
                              ?.firstWhereOrNull((ser) =>
                                  ser.serviceId ==
                                  controller.selectedService.value)
                              ?.serviceTypes
                              ?.firstWhereOrNull(
                                  (type) => type.serviceType == 'online') !=
                          null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person),
                                    space16,
                                    Text(
                                      'Биечлэн уулзах',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    )
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      if (controller.selectedLawyer.value !=
                                          null) {
                                        controller.selectedServiceType.value =
                                            controller.selectedLawyer.value
                                                ?.userServices!
                                                .firstWhere((ser) =>
                                                    ser.serviceId ==
                                                    controller
                                                        .selectedService.value)
                                                .serviceTypes!
                                                .firstWhere((type) =>
                                                    type.serviceType ==
                                                    'online');
                                        Navigator.of(context).push(
                                            createRoute(const OrderView()));
                                      }
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios)),
                              ]),
                        )
                      : space24,
              controller.selectedLawyer.value?.userServices?.firstWhereOrNull(
                          (ser) =>
                              ser.serviceId ==
                              controller.selectedService.value) ==
                      null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.camera),
                            space16,
                            Text(
                              'Онлайн зөвлөгөө авах',
                              style: Theme.of(context).textTheme.displayMedium,
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              controller.selectedServiceType.value =
                                  ServiceTypes(serviceType: 'onlineEmergency');
                              controller.getSuggestLawyer('', '',
                                  controller.selectedService.value, context);
                            },
                            icon: const Icon(Icons.arrow_forward_ios))
                      ],
                    )
                  : controller.selectedLawyer.value?.userServices
                              ?.firstWhereOrNull((ser) =>
                                  ser.serviceId ==
                                  controller.selectedService.value)
                              ?.serviceTypes
                              ?.firstWhereOrNull((type) =>
                                  type.serviceType == 'onlineEmergency') !=
                          null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.camera),
                                space16,
                                Text(
                                  'Онлайн зөвлөгөө авах',
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                )
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  controller.selectedServiceType.value =
                                      controller
                                          .selectedLawyer.value?.userServices!
                                          .firstWhere((ser) =>
                                              ser.serviceId ==
                                              controller.selectedService.value)
                                          .serviceTypes!
                                          .firstWhere((type) =>
                                              type.serviceType ==
                                              'onlineEmergency');
                                  Navigator.of(context)
                                      .push(createRoute(const OrderView()));
                                },
                                icon: const Icon(Icons.arrow_forward_ios))
                          ],
                        )
                      : const SizedBox(),
              space24
            ],
          ),
        ),
      ],
    );
  }
}
