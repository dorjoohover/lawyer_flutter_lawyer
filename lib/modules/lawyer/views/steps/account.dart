import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerRegisterController());
    return Screen(
      step: 8,
        title: 'Банкны мэдээлэл',
        children: [
          space32,
          Text(
            'Цалин авах дансны мэдээллээ оруулна уу.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          space32,
          Input(
              onChange: (p0) {
                print(p0);
                controller.lawyer.value?.account?.accountNumber = int.parse(p0);
                check(controller);
              },
              textInputType: TextInputType.number,
              labelText: 'Дансны дугаар'),
          space32,
          Input(
              onChange: (p0) {
                controller.lawyer.value?.account?.username = p0;

                check(controller);
              },
              labelText: 'Данс эзэмшигчийн нэр'),
          space32,
          Input(
              onChange: (p0) {
                controller.lawyer.value?.account?.bank = p0;
                check(controller);
              },
              labelText: 'Банкны нэр'),
          space32,
          Input(
              onChange: (p0) {
                controller.lawyer.value?.taxNumber = p0;
                check(controller);
              },
              labelText: 'Татвар төлөгчийн дугаар'),
          space32,
        ],
        child: Obx(() => MainButton(
              onPressed: () {
                Navigator.push(context, createRoute(const AdditionWidget()));
              },
              disabled: !controller.account.value,
              text: "Үргэлжлүүлэх",
              child: const SizedBox(),
            )));
  }

  void check(LawyerRegisterController controller) {
    if (controller.lawyer.value?.account?.accountNumber != null &&
        controller.lawyer.value?.account?.username != '' &&
        controller.lawyer.value?.taxNumber != '' &&
        controller.lawyer.value?.account?.bank != '') {
      controller.account.value = true;
    } else {
      controller.account.value = false;
    }
  }
}
