import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/widgets/order_detail.dart';
import 'package:get/get.dart';

import '../../../shared/index.dart';

class OrdersView extends GetView<PrimeController> {
  const OrdersView({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg,
        appBar: PrimeAppBar(
          title: title,
          onTap: () {
            Get.to(() => const PrimeView());
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: large, horizontal: origin),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: controller.orders.map((e) {
                return GestureDetector(
                  onTap: () {
                    // controller.getSuggestLawyer(
                    //     e.title!, e.description!, e.sId!);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: origin),
                    child: OrderDetailView(
                        onTap: () async {
                          await controller.getChannelToken(
                              e.sId!, e.channelName!, e.serviceType!, context);
                        },
                        type: e.serviceType ?? '',
                        name: e.lawyerId?.firstname ?? '',
                        status: e.serviceStatus ?? '',
                        profession: '${e.channelName}'),
                  ),
                );
              }).toList(),
            ),
          ),
        ));
  }
}
