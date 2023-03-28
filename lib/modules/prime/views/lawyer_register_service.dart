import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

import '../../../shared/index.dart';

class LawyerRegisterServiceView extends GetView<PrimeController> {
  const LawyerRegisterServiceView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final lawyerController = Get.put(LawyerController());
    return Scaffold(
        backgroundColor: bg,
        appBar: PrimeAppBar(
          title: 'Нэмэлт мэдээлэл',
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: large, horizontal: origin),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: controller.services.map((e) {
                return GestureDetector(
                  onTap: () {
                    lawyerController.selectedServices.add(e.sId!);
                    controller.getSubServices(e.sId!, e.title!);
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: origin),
                      child: ServiceCard(text: e.title ?? '')),
                );
              }).toList(),
            ),
          ),
        ));
  }
}
