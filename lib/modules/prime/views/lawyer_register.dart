import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class LawyerRegisterView extends GetView<LawyerController> {
  LawyerRegisterView({Key? key}) : super(key: key);

  final controller = Get.put(LawyerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrimeAppBar(
            onTap: () {
              Navigator.of(context).pop();
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
                  Text(
                    'Өөрийн танилцуулгаа оруулна уу.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  space32,
                  Input(
                      onChange: (p0) {
                        controller.bio.value = p0;
                      },
                      labelText: 'Танилцуулга'),
                  space32,
                  Input(
                      onChange: (p0) {
                        controller.experience.value = p0.toString();
                      },
                      textInputType: TextInputType.number,
                      labelText: 'Туршлага'),
                ],
              ),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 50,
                  left: 0,
                  right: 0,
                  child: Obx(() => MainButton(
                        onPressed: () {
                          Get.to(() => LawyerRegisterServiceView());
                        },
                        disabled: controller.bio.value == "" ||
                            controller.experience.value == "",
                        text: "Үргэлжлүүлэх",
                        child: const SizedBox(),
                      )))
            ],
          ),
        ));
  }
}
