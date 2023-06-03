import 'package:flutter/material.dart';
import 'package:frontend/modules/auth/auth.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class RegisterPhoneView extends StatelessWidget {
  RegisterPhoneView({Key? key}) : super(key: key);
  final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrimeAppBar(
            onTap: () {
              Navigator.pop(context);
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
                    'Таны бүртгүүлсэн утасны дугаар таны аппликэйшнд Hэвтрэх нэр болохыг анхаарна уу',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  space32,
                  Input(
                    textInputType: TextInputType.number,
                    labelText: 'Утасны дугаар',
                    onChange: (p0) => {controller.registerPhone.value = p0},
                  ),
                ],
              ),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 50,
                  left: 0,
                  right: 0,
                  child: Obx(() => MainButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(createRoute(RegisterPasswordView()));
                        },
                        disabled: controller.registerPhone.value == "",
                        text: "Үргэлжлүүлэх",
                        child: const SizedBox(),
                      )))
            ],
          ),
        ));
  }
}
