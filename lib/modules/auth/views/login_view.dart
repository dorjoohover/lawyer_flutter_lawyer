import 'package:flutter/material.dart';
import 'package:frontend/modules/auth/auth.dart';
import 'package:frontend/modules/auth/widgets/input_label.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(origin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16),
                      child: Image.asset(
                        imageLogo,
                        width: MediaQuery.of(context).size.width > 400
                            ? 200
                            : MediaQuery.of(context).size.width * 0.5,
                      ),
                    ),
                    Column(
                      children: [
                        Input(
                          focusNode: controller.phoneFocus,
                          labelText: 'Утасны дугаар',
                          onChange: (p0) => {controller.phone.value = p0},
                        ),
                        space16,
                        Obx(
                          () => Input(
                              focusNode: controller.passwordFocus,
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    !controller.isVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    controller.isVisible.value =
                                        !controller.isVisible.value;
                                  }),
                              obscureText: controller.isVisible.value,
                              labelText: 'Нууц үг',
                              tController: controller.loginPasswordController,
                              onChange: (p0) => {}),
                        ),
                        space16,
                        MainButton(
                          onPressed: () {},
                          borderColor: Colors.transparent,
                          color: Colors.transparent,
                          contentColor: primary,
                          text: 'Нууц үг мартсан',
                          child: const SizedBox(),
                        ),
                      ],
                    ),
                    space16,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MainButton(
                          onPressed: () async {
                            controller.login(context);
                          },
                          text: 'Нэвтрэх',
                          child: const SizedBox(),
                        ),
                        space16,
                        MainButton(
                          onPressed: () {
                            Get.to(() => RegisterView());
                          },
                          color: Colors.transparent,
                          contentColor: primary,
                          text: 'Бүртгүүлэх',
                          child: const SizedBox(),
                        ),
                        space16,
                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
