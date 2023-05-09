import 'package:flutter/material.dart';
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
              Padding(
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
                            style: Theme.of(context).textTheme.displayMedium,
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            controller.order.value?.serviceType = 'fulfilled';
                            if (controller.selectedLawyer.value != null) {
                              controller.getTimeLawyer(context);
                            } else {
                              controller.getTimeService(context);
                            }
                          },
                          icon: const Icon(Icons.arrow_forward_ios)),
                    ]),
              ),
              Row(
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
                        controller.order.value?.serviceType = 'online';
                        if (controller.selectedLawyer.value != null) {
                          controller.getTimeLawyer(context);
                        } else {
                          controller.getTimeService(context);
                        }
                      },
                      icon: const Icon(Icons.arrow_forward_ios))
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
