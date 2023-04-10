import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class LawyerRegisterService extends StatelessWidget {
  const LawyerRegisterService({super.key});

  Widget build(BuildContext context) {
    final primeController = Get.put(PrimeController());
    final controller = Get.put(LawyerController());

    return Scaffold(
        appBar: PrimeAppBar(
            onTap: () {
              Navigator.pop(context);
            },
            title: "Үйлчилгээ сонгох"),
        backgroundColor: bg,
        body: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: origin,
                right: origin),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: LawyerServiceWidget(
              isBtn: false,
              onPress: () {},
              submitText: 'Цааш',
              children: primeController.services.map((e) {
                return GestureDetector(
                  onTap: () async {
                   
                    final res = await primeController.getSubServices(e.sId!);
                    if (res && primeController.subServices.isNotEmpty) {
                      Navigator.of(context)
                          .push(createRoute(LawyerRegisterSubService(
                        subServices: primeController.subServices,
                      )));
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: origin),
                      child: ServiceCard(text: e.title ?? '')),
                );
              }).toList(),
            )));
  }
}
