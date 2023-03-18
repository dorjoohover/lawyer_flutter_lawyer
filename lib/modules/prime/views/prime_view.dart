import 'package:flutter/material.dart';
import 'package:frontend/modules/prime/prime.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class PrimeView extends GetView<PrimeController> {
  const PrimeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final authCtrl = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: MainAppBar(
        title: 'Нүүр',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // await controller.getTournaments();
        },
        child: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '1vs1 Battle',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7851A2),
                    ),
                  ),
                  Text(
                    'Find a match and battle now!',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
