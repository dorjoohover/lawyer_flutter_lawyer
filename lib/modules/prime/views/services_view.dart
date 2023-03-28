import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

import '../../../shared/index.dart';

class ServicesView extends GetView<PrimeController> {
  const ServicesView({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final lawyerController = Get.put(LawyerController());
    return Scaffold(
        backgroundColor: bg,
        appBar: PrimeAppBar(
          title: title,
          onTap: () {
            Get.to(() => const PrimeView());
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: large, horizontal: origin),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: controller.subServices.map((e) {
                return GestureDetector(
                  onTap: () {
                    lawyerController.selectedAvailableDays.value?.date = e.sId!;
                    Get.to(() => LawyerAvailableDays(
                          onPressed: () async {
                            await lawyerController.sendAddition();
                          },
                        ));
                  },
                  child: ServiceCard(text: e.title ?? ''),
                );
              }).toList(),
            ),
          ),
        ));
  }
}
