import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class PrimeLawyer extends GetView<PrimeController> {
  const PrimeLawyer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg,
        body: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(
                            "https://images.unsplash.com/photo-1605664041952-4a2855d9363b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80",
                          ),
                          fit: BoxFit.cover,
                        )),
                        child: Padding(
                          padding: EdgeInsets.only(top: large, left: origin),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )),
                  ),
                  space16,
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: origin),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.selectedLawyer.value
                                                ?.lastName ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      space4,
                                      Text(
                                        'Хуульч',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ],
                                  )),
                                  space16,
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Туршлага",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall,
                                              ),
                                              space4,
                                              Text(
                                                "${controller.selectedLawyer.value?.experience} жил",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ],
                                          )),
                                          space16,
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Үнэлгээ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall,
                                              ),
                                              space4,
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: gold,
                                                  ),
                                                  space8,
                                                  Text(
                                                    "${controller.selectedLawyer.value?.ratingAvg ?? 0}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                        ],
                                      )
                                    ],
                                  )),
                                ],
                              ),
                              space16,
                              Container(
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.start,
                                    spacing: 12,
                                    children: controller.lawyerPrice.map((e) {
                                      return OrderCard(
                                        expiredTime:
                                            int.parse(e.expiredTime ?? '0'),
                                        price:
                                            double.parse('${e.price ?? '0'}'),
                                        type: e.serviceType!,
                                      );
                                    }).toList()),
                              ),
                              space16,
                              Container(
                                padding: const EdgeInsets.all(origin),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(origin),
                                    color: Colors.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Миний тухай',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    space16,
                                    Text(
                                      controller.selectedLawyer.value?.bio ??
                                          '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                    space8,
                                    Align(
                                        child: Transform.rotate(
                                      angle: -pi / 2,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.arrow_back_ios),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              space16,
                              controller.selectedLawyer.value?.rating != null
                                  ? ClientRatingWidget(
                                      ratings: controller
                                          .selectedLawyer.value!.rating!)
                                  : const SizedBox(),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).padding.bottom + 126,
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 50,
                  left: 16,
                  right: 16,
                  child: MainButton(
                    onPressed: () {
                      Get.bottomSheet(
                          isScrollControlled: true,
                          OrderBottomSheet(
                            title: 'Захиалгын төрөл сонгоно уу',
                          ));
                    },
                    text: "Захиалга",
                    child: const SizedBox(),
                  ))
            ],
          ),
        ));
  }
}
