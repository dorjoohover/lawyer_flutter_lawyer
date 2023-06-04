import 'package:flutter/material.dart';
import 'package:frontend/modules/auth/auth.dart';
import 'package:frontend/modules/emergency/emergency.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class AdditionView extends StatelessWidget {
  const AdditionView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmergencyController());
    return Scaffold(
        appBar: PrimeAppBar(
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Нэмэлт мэдээлэл'),
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
                  Input(
                    labelText: 'Уулзах шалтгаанаа бичиж оруулна уу',
                    onChange: (p0) => controller.reason.value = p0,
                  )
                ],
              ),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 50,
                  left: 0,
                  right: 0,
                  child: MainButton(
                    onPressed: () async {
                      if (controller.serviceType.value == 'onlineEmergency') {
                        bool res = await controller.sendOrder();
                        if (res) {
                          
                          Navigator.push(
                              context, createRoute(const SuccessView()));
                        }
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LocationView()));
                      }
                    },
                    text: controller.serviceType.value == 'onlineEmergency'
                        ? "Төлбөр төлөх"
                        : 'Үргэлжлүүлэх',
                    child: const SizedBox(),
                  ))
            ],
          ),
        ));
  }
}
