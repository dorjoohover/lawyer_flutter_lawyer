import 'package:flutter/material.dart';
import 'package:frontend/modules/home/controllers/controllers.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    return Scaffold(
      appBar: PrimeAppBar(
        title: 'Цаг авах',
        onTap: () => Navigator.of(context).pop(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: origin),
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
                                      colorScheme:
                                          ColorScheme.light(primary: primary)),
                                  child: child!,
                                );
                              },
                              context: context,
                              initialDate: controller.selectedDate.value,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100));
                          if (pickedDate != null)
                            controller.selectedDate.value = pickedDate;
                        },
                        icon: Icon(Icons.calendar_today)),
                    Obx(() => Text(controller.selectedDate.value.toString()))
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  space4,
                                  Text(
                                    'Дав',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  space8,
                                  Text(
                                    '1',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  space4
                                ],
                              ),
                            )),
                            space8,
                            Expanded(
                                flex: 4,
                                child: GridView.count(
                                  shrinkWrap: true,
                                  mainAxisSpacing: small,
                                  crossAxisSpacing: small,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  children: List.generate(
                                    16,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        controller.selectedTime.value = '10:00';
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.white),
                                          child: Text(
                                            '10:00',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(color: primary),
                                          )),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  space4,
                                  Text(
                                    'Дав',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  space8,
                                  Text(
                                    '1',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  space4
                                ],
                              ),
                            )),
                            space8,
                            Expanded(
                                flex: 4,
                                child: GridView.count(
                                  shrinkWrap: true,
                                  mainAxisSpacing: small,
                                  crossAxisSpacing: small,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  children: List.generate(
                                    16,
                                    (index) => Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white),
                                        child: Text(
                                          '10:00',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: primary),
                                        )),
                                  ),
                                )),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  space4,
                                  Text(
                                    'Дав',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  space8,
                                  Text(
                                    '1',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  space4
                                ],
                              ),
                            )),
                            space8,
                            Expanded(
                                flex: 4,
                                child: GridView.count(
                                  shrinkWrap: true,
                                  mainAxisSpacing: small,
                                  crossAxisSpacing: small,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  children: List.generate(
                                    16,
                                    (index) => Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white),
                                        child: Text(
                                          '10:00',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: primary),
                                        )),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 126,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 50,
                left: 16,
                right: 16,
                child: MainButton(
                  onPressed: () {
                    Get.to(() => FileUploadView());
                  },
                  text: "Үргэлжлүүлэх",
                  child: const SizedBox(),
                ))
          ],
        ),
      ),
    );
  }
}
