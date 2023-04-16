import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../shared/index.dart';

class OrdersView extends GetView<PrimeController> {
  const OrdersView({super.key, required this.title, required this.isLawyer});
  final String title;
  final bool isLawyer;
  @override
  Widget build(BuildContext context) {
    final lawyerController = Get.put(LawyerController());
    return Scaffold(
        backgroundColor: bg,
        appBar: PrimeAppBar(
          title: title,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        body: Container(
          padding:
              const EdgeInsets.symmetric(vertical: large, horizontal: origin),
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
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
                            lawyerController.getChannelToken(
                                e.sId!,
                                e.channelName!,
                                e.serviceType!,
                                context,
                                isLawyer,
                                isLawyer
                                    ? e.clientId?.lastName ?? ""
                                    : e.lawyerId?.lastName ?? "",
                                '');
                          },
                          date: DateFormat('yyyy/MM/dd').format(
                              DateTime.fromMillisecondsSinceEpoch(e.date!)),
                          time: DateFormat('hh:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(e.date!)),
                          type: e.serviceType ?? "",
                          name: isLawyer
                              ? e.clientId?.lastName ?? ""
                              : e.lawyerId?.lastName ?? "",
                          status: e.serviceStatus ?? "",
                          profession: isLawyer ? 'Үйлчлүүлэгч' : "Хуульч")),
                );
              }).toList(),
            ),
          ),
        ));
  }
}
