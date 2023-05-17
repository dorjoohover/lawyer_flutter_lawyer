import 'package:flutter/material.dart';
import 'package:frontend/modules/auth/auth.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class RegisterPasswordView extends StatelessWidget {
  RegisterPasswordView({Key? key}) : super(key: key);
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
                    '8 оронтой, том, жижиг үсэг, тоо орсон байх шаардлагатай',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  space32,
                  Obx(
                    () => Input(
                        focusNode: controller.registerPasswordFocus,
                        suffixIcon: IconButton(
                            icon: Icon(
                              controller.registerPasswordIsVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              controller.registerPasswordIsVisible.value =
                                  !controller.registerPasswordIsVisible.value;
                            }),
                        obscureText:
                            !controller.registerPasswordIsVisible.value,
                        labelText: 'Нууц үг',
                        tController: controller.registerPasswordController,
                        onChange: (p0) =>
                            {controller.registerPassword.value = p0}),
                  ),
                  space16,
                  Obx(
                    () => Input(
                        focusNode: controller.registerPasswordRepeatFocus,
                        suffixIcon: IconButton(
                            icon: Icon(
                              controller.registerPasswordRepeatIsVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              controller.registerPasswordRepeatIsVisible.value =
                                  !controller
                                      .registerPasswordRepeatIsVisible.value;
                            }),
                        obscureText:
                            !controller.registerPasswordRepeatIsVisible.value,
                        labelText: 'Нууц үг дахин оруулах',
                        tController:
                            controller.registerPasswordRepeatController,
                        onChange: (p0) =>
                            {controller.registerPasswordRepeat.value = p0}),
                  ),
                ],
              ),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 50,
                  left: 0,
                  right: 0,
                  child: Obx(
                    () => MainButton(
                      onPressed: () async {
                        await controller.register(context);
                      },
                      disabled: (controller.registerPassword.value !=
                              controller.registerPasswordRepeat.value ||
                          controller.registerPassword.value.length < 8),
                      text: "Бүртгүүлэх",
                      child: const SizedBox(),
                    ),
                  ))
            ],
          ),
        ));
  }
}
