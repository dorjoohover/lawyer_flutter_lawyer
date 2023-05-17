import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class LawyerAvailableDays extends StatefulWidget {
  const LawyerAvailableDays({super.key});

  @override
  State<LawyerAvailableDays> createState() => _LawyerAvailableDaysState();
}

class _LawyerAvailableDaysState extends State<LawyerAvailableDays> {
  final List<int> selectedDays = [];
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerController());
    return Scaffold(
        appBar: PrimeAppBar(
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Боломжит цаг сонгох'),
        backgroundColor: bg,
        body: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: origin,
                right: origin),
            height: MediaQuery.of(context).size.height,
            child: LawyerServiceWidget(
              onPress: () async {
                final res = await controller.addAvailableDays();
                if (res) {
                  Get.snackbar('Амжилттай', "asdf", backgroundColor: success);
                  Navigator.of(context).push(createRoute(const LawyerView()));
                }
              },
              children: [
                space32,
                Text(
                  'Боломжит цаг сонгох',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                space32,
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.selectedDate.value.month >
                            DateTime.now().month) {
                          controller.selectedDate.value = DateTime(
                              controller.selectedDate.value.year,
                              controller.selectedDate.value.month - 1,
                              controller.selectedDate.value.day);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: small, bottom: small, left: 12, right: tiny),
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
                      () => Text("${controller.selectedDate.value.month}-р сар",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontWeight: FontWeight.w600)),
                    ),
                    space8,
                    GestureDetector(
                      onTap: () {
                        controller.selectedDate.value = DateTime(
                            controller.selectedDate.value.year,
                            controller.selectedDate.value.month + 1,
                            controller.selectedDate.value.day);
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
                    children: List.generate(31, (e) {
                      int lastDay = DateTime(controller.selectedDate.value.year,
                              controller.selectedDate.value.month + 1, 0)
                          .day;
                      int startDay = 1;
                      if (DateTime.now().year ==
                              controller.selectedDate.value.year &&
                          DateTime.now().month ==
                              controller.selectedDate.value.month) {
                        startDay = DateTime.now().day;
                      }

                      if (e + 1 >= startDay && e + 1 <= lastDay) {
                        return LawyerAvailableDay(
                          day: e + 1,
                        );
                      } else {
                        return const SizedBox();
                      }
                    }).toList(),
                  ),
                ))),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 106,
                )
              ],
            )));
  }
}
