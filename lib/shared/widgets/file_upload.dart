import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class FileUploadView extends GetView<OrderController> {
  const FileUploadView({super.key});
  @override
  Widget build(BuildContext context) {
    final primeController = Get.find<PrimeController>();
    final controller = Get.put(OrderController());
    return Scaffold(
      appBar: PrimeAppBar(
        title: 'Нэмэлт мэдээлэл',
        onTap: () => Navigator.of(context).pop(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: origin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: large),
              child: Text(
                'Танд хавсаргах файл байгаа юу?',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: MainButton(
                      onPressed: () {},
                      text: "Файл хавсаргах",
                      child: const SizedBox(),
                      color: Colors.white,
                      contentColor: primary,
                    ),
                  ),
                  space16,
                  SizedBox(
                    width: double.infinity,
                    child: MainButton(
                      onPressed: () {
                        controller.createOrder("6414981cf5e1943905b42cc5",
                            primeController.selectedServiceType.value);
                      },
                      text: "Алгасах",
                      child: const SizedBox(),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 50,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
