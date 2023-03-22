import 'package:flutter/material.dart';
import 'package:frontend/modules/auth/auth.dart';
import 'package:frontend/modules/auth/widgets/widgets.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  RegisterView({Key? key}) : super(key: key);
  final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrimeAppBar(
            onTap: () {
              Get.to(() => LoginView());
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
                    'Овог, нэрээ оруулна уу',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  space32,
                  Input(
                    focusNode: controller.firstnameFocus,
                    labelText: 'Овог',
                    onChange: (p0) => {controller.firstname.value = p0},
                  ),
                  space16,
                  Input(
                    focusNode: controller.lastnameFocus,
                    labelText: 'Нэр',
                    onChange: (p0) => {controller.lastname.value = p0},
                  ),
                ],
              ),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 50,
                  left: 0,
                  right: 0,
                  child: Obx(() => MainButton(
                        onPressed: () {
                          Get.to(() => RegisterNumberView());
                        },
                        disabled: controller.lastname.value == "" ||
                            controller.firstname.value == '',
                        text: "Үргэлжлүүлэх",
                        child: const SizedBox(),
                      )))
            ],
          ),
        ));
  }
}
