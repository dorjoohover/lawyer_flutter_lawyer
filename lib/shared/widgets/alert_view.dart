import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

import '../../shared/index.dart';

class AlertView extends StatelessWidget {
  const AlertView({super.key, required this.status, required this.text});
  final String status;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: origin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            space32,
            Column(
              children: [
                Icon(
                  Icons.check_box,
                  size: 120,
                  color: success,
                ),
                space32,
                space16,
                Text(
                  "Амжилттай",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                space16,
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 50),
              width: double.infinity,
              child: MainButton(
                onPressed: () {
                  Get.to(() => PrimeView());
                },
                text: "Үндсэн цэс рүү буцах",
                child: const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
