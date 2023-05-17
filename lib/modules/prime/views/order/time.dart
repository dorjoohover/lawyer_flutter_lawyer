import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

import '../../../../shared/index.dart';

class OrderTimeView extends GetView<PrimeController> {
  const OrderTimeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg,
        appBar: PrimeAppBar(
          title: 'Цаг сонгох',
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
              padding: const EdgeInsets.only(
                  bottom: origin, left: origin, right: origin),
              height: defaultHeight(context) + 80,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        space32,
                        Text(
                          'Боломжит цагууд',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        space32,
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (controller.times.any((element) =>
                                    element.day! >=
                                    controller.selectedDate.value
                                            .millisecondsSinceEpoch +
                                        2592000000)) {
                                  controller.selectedDate.value
                                          .millisecondsSinceEpoch +
                                      2592000000;
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: small,
                                    bottom: small,
                                    left: 12,
                                    right: tiny),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: lightGray,
                                    borderRadius: BorderRadius.circular(large)),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  weight: 2,
                                  size: 16,
                                ),
                              ),
                            ),
                            space8,
                            Obx(
                              () => Text(
                                  "${controller.selectedDate.value.month}-р сар",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(fontWeight: FontWeight.w600)),
                            ),
                            space8,
                            GestureDetector(
                              onTap: () {
                                if (controller.times.any((element) =>
                                    element.day! <=
                                    controller.selectedDate.value
                                            .millisecondsSinceEpoch -
                                        2592000000)) {
                                  controller.selectedDate.value
                                          .millisecondsSinceEpoch -
                                      2592000000;
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(small),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: lightGray,
                                    borderRadius: BorderRadius.circular(large)),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  weight: 2,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        space32,
                        Expanded(
                            child: SingleChildScrollView(
                                child: Obx(
                          () => Column(
                              children: controller.times.map((time) {
                            if (time.day != 0) {
                              return OrderTimeWidget(
                                day: time.day!,
                                time: time.time ?? [],
                              );
                            } else {
                              return const SizedBox();
                            }
                          }).toList()),
                        ))),
                      ]),
                  Positioned(
                      bottom: MediaQuery.of(context).padding.bottom,
                      left: 16,
                      right: 16,
                      child: MainButton(
                        onPressed: () async {
                          bool res = await controller.sendOrder();
                          if (res) {
                            Navigator.of(context).push(createRoute(AlertView(
                                status: 'success',
                                text:
                                    'Таны сонгосон хуульчтайгаа ${controller.selectedDate.value.year} / ${controller.selectedDate.value.month} / ${controller.selectedDate.value.day}-ны өдрийн ${controller.selectedDate.value.hour}:00 дуудлагаа хийнэ үү ')));
                          }
                        },
                        text: "Захиалга",
                        child: const SizedBox(),
                      ))
                ],
              )),
        ));
  }
}
