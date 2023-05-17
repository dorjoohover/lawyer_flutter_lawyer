import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class LawyerAvailableDay extends StatelessWidget {
  const LawyerAvailableDay({super.key, required this.day});

  final int day;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerController());
    int currentDay = DateTime(controller.selectedDate.value.year,
            controller.selectedDate.value.month, day)
        .millisecondsSinceEpoch;
    int afterDay = DateTime(controller.selectedDate.value.year,
            controller.selectedDate.value.month, day + 1)
        .millisecondsSinceEpoch;
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
                        color: controller.timeDetail
                                .where((t) =>
                                    t.time! >= currentDay && t.time! < afterDay)
                                .isNotEmpty
                            ? Colors.black
                            : Colors.white),
                    child: Column(
                      children: [
                        space4,
                        Obx(
                          () => Text(
                            getDay(DateTime(controller.selectedDate.value.year,
                                controller.selectedDate.value.month, day)),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: controller.timeDetail
                                            .where((t) =>
                                                t.time! >= currentDay &&
                                                t.time! < afterDay)
                                            .isNotEmpty
                                        ? Colors.white
                                        : primary),
                          ),
                        ),
                        space8,
                        Obx(
                          () => Text(
                            '$day',
                            style:
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color:
                                            controller.timeDetail
                                                    .where((t) =>
                                                        t.time! >= currentDay &&
                                                        t.time! < afterDay)
                                                    .where(
                                                        (t) =>
                                                            t.time! >=
                                                                currentDay &&
                                                            t.time! < afterDay)
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
                    int time = DateTime(
                            controller.selectedDate.value.year,
                            controller.selectedDate.value.month,
                            day,
                            int.parse(e.substring(0, 2)))
                        .millisecondsSinceEpoch;
                    return GestureDetector(
                        onTap: () {
                          if (controller.timeDetail
                                  .firstWhere((p0) => p0.time == time,
                                      orElse: () => TimeDetail(time: 0))
                                  .time ==
                              0) {
                            controller.timeDetail
                                .add(TimeDetail(time: time, status: 'active'));
                          } else {
                            controller.timeDetail
                                .removeWhere((t) => t.time == time);
                          }
                        },
                        child: Obx(() => Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.timeDetail
                                            .firstWhere((p0) => p0.time == time,
                                                orElse: () =>
                                                    TimeDetail(time: 0))
                                            .time !=
                                        0
                                    ? primary
                                    : Colors.white),
                            child: Text(
                              e,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: controller.timeDetail
                                                  .firstWhere(
                                                      (p0) => p0.time == time,
                                                      orElse: () =>
                                                          TimeDetail(time: 0))
                                                  .time !=
                                              0
                                          ? Colors.white
                                          : primary),
                            ))));
                  }).toList())),
        ],
      ),
    );
  }
}
