import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/auth/auth.dart';
import 'package:frontend/modules/prime/controllers/controllers.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LawyerAvailableDays extends GetView<LawyerController> {
  LawyerAvailableDays({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrimeAppBar(
            onTap: () {
              Get.to(() => RegisterView());
            },
            title: 'Бүртгүүлэх'),
        backgroundColor: bg,
        body: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: origin,
              right: origin),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  space32,
                  Text(
                    'Боломжит өдрүүд',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  space32,
                  Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                            primary: primary)),
                                    child: child!,
                                  );
                                },
                                context: context,
                                initialDate: controller.selectedDate.value,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100));
                            if (pickedDate != null) {
                              controller.selectedAvailableDays[0].date =
                                  pickedDate.millisecondsSinceEpoch.toString();
                              controller.selectedDate.value = pickedDate;
                              print(controller.selectedAvailableDays[0].date);
                            }
                          },
                          icon: Icon(Icons.calendar_today)),
                      Obx(() => Text(
                          "${controller.selectedDate.value.year}-${controller.selectedDate.value.month}"))
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                        child: Obx(
                      () => Column(
                        children: List.generate(31, (e) {
                          DateTime now = DateTime.now();
                          int lastday = DateTime(
                                  controller.selectedDate.value.year,
                                  controller.selectedDate.value.month + 1,
                                  0)
                              .day;

                          if (now.month ==
                                  controller.selectedDate.value.month &&
                              now.year == controller.selectedDate.value.year) {
                            if (e + 1 >= now.day && e + 1 <= lastday) {
                              final day =
                                  getDay(DateTime(now.year, now.month, e));
                              return AvailableDays(
                                controller: controller,
                                day: day,
                                dayNum: e + 1,
                              );
                            }
                          } else {
                            if (e + 1 <= lastday) {
                              final day = getDay(DateTime(
                                  controller.selectedDate.value.year,
                                  controller.selectedDate.value.month,
                                  e));
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => LawyerAvailableDays());
                                },
                                // child: ServiceCard(text: e.title ?? ''),
                                child: AvailableDays(
                                  controller: controller,
                                  day: day,
                                  dayNum: e + 1,
                                ),
                              );
                            }
                          }
                          return SizedBox();
                        }).toList(),
                      ),
                    )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 106,
                  ),
                ],
              ),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 50,
                  left: 0,
                  right: 0,
                  child: MainButton(
                    onPressed: () async {
                  
                      await controller.sendAddition();
                    },
                    text: "Илгээх",
                    child: const SizedBox(),
                  ))
            ],
          ),
        ));
  }

  String getDay(DateTime day) {
    final eDay = DateFormat('EEEE').format(day);

    switch (eDay) {
      case 'Monday':
        return "Дав";

      case 'Tuesday':
        return "Мя";

      case 'Wednesday':
        return "Лха";

      case 'Thursday':
        return "Пү";

      case 'Friday':
        return "Ба";

      case 'Saturday':
        return "Бя";

      case 'Sunday':
        return "Ня";
      default:
        return "";
    }
  }
}

class AvailableDays extends StatelessWidget {
  const AvailableDays(
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
      margin: EdgeInsets.symmetric(vertical: origin),
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
