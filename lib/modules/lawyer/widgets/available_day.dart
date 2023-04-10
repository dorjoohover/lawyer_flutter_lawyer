import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LawyerAvailableDay extends StatelessWidget {
  const LawyerAvailableDay(
      {super.key,
      required this.day,
      required this.dayNum,
      required this.controller});
  final LawyerController controller;
  final String day;
  final int dayNum;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: origin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Obx(() => Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: controller.selectedDay
                                .where((e) => e.day == dayNum.toString())
                                .isNotEmpty
                            ? Colors.black
                            : Colors.white),
                    child: Column(
                      children: [
                        space4,
                        Obx(
                          () => Text(
                            day,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: controller.selectedDay
                                            .where((e) =>
                                                e.day == dayNum.toString())
                                            .isNotEmpty
                                        ? Colors.white
                                        : primary),
                          ),
                        ),
                        space8,
                        Obx(
                          () => Text(
                            '$dayNum',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: controller
                                            .selectedDay
                                            .where((e) =>
                                                e.day == dayNum.toString())
                                            .isNotEmpty
                                        ? Colors.white
                                        : primary),
                          ),
                        ),
                        space4
                      ],
                    ),
                  ))),
          space8,
          Expanded(
              flex: 4,
              child: GridView.count(
                  shrinkWrap: true,
                  mainAxisSpacing: small,
                  crossAxisSpacing: small,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: availableTimes.map((e) {
                    return GestureDetector(
                        onTap: () {
                          final w = controller.selectedDay
                              .where((e) => e.day == dayNum.toString());
                          print(w);
                          if (w.isNotEmpty) {
                            final whereTime =
                                w.first.time?.where((t) => t == e);
                            if (whereTime!.isEmpty) {
                              controller.selectedTime.add(SelectedTime(
                                  day: dayNum.toString(), time: e));

                              controller.selectedDay
                                  .where((e) => e.day == dayNum.toString())
                                  .first
                                  .time
                                  ?.add(e);
                            }
                          } else {
                            controller.selectedDay.add(AvailableTime(
                              date: DateTime.parse(
                                      "${DateFormat('yyyy-MM-dd').format(DateTime(
                                controller.selectedDate.value.year,
                                controller.selectedDate.value.month + 1,
                                dayNum,
                              ))}T$e")
                                  .toLocal()
                                  .millisecondsSinceEpoch,
                              day: dayNum.toString(),
                              time: [e],
                            ));
                            controller.selectedTime.add(
                                SelectedTime(day: dayNum.toString(), time: e));
                          }
                        },
                        child: Obx(() => Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.selectedTime
                                        .where((t) =>
                                            t.day == dayNum.toString() &&
                                            t.time == e)
                                        .isNotEmpty
                                    ? primary
                                    : Colors.white),
                            child: Obx(() => Text(
                                  e,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: controller.selectedTime
                                                  .where((t) =>
                                                      t.day ==
                                                          dayNum.toString() &&
                                                      t.time == e)
                                                  .isNotEmpty
                                              ? Colors.white
                                              : primary),
                                )))));
                  }).toList())),
        ],
      ),
    );
  }
}
