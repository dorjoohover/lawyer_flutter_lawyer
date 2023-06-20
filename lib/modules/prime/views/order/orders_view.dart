import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/modules/prime/views/maps.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../shared/index.dart';

class OrdersView extends GetView<PrimeController> {
  const OrdersView({super.key, required this.title, required this.isLawyer});
  final String title;
  final bool isLawyer;
  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
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
              const EdgeInsets.only(bottom: large, right: origin, left: origin),
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: AnimationLimiter(
                child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 1000),
                childAnimationBuilder: (p0) => SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: p0,
                    )),
                children: controller.orders.map((e) {
                  return Container(
                      margin: const EdgeInsets.only(bottom: origin),
                      child: OrderDetailView(
                          onTap: () async {
                            if (e.serviceType == 'online' ||
                                e.serviceType == 'onlineEmergency') {
                              homeController.getChannelToken(e, isLawyer, '');
                            } else {
                              if (e.serviceType == 'fulfilled') {
                                Get.to(() => OrderTrackingPage(
                                    isLawyer: false,
                                    location: e.location ??
                                        LocationDto(lat: 0.0, lng: 0.0)));
                                Navigator.push(
                                    context,
                                    createRoute(OrderTrackingPage(
                                        isLawyer: false,
                                        location: e.location ??
                                            LocationDto(lat: 0.0, lng: 0.0))));
                              } else {
                                Navigator.push(
                                    context,
                                    createRoute(UserOrderMapPageView(
                                        lawyerId: e.lawyerId!.sId!,
                                        location: e.location ??
                                            LocationDto(lat: 0.0, lng: 0.0))));
                              }
                            }
                          },
                          date: DateFormat('yyyy/MM/dd').format(
                              DateTime.fromMillisecondsSinceEpoch(e.date!)),
                          time: DateFormat('hh:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(e.date!)),
                          type: e.serviceType ?? "",
                          name: isLawyer
                              ? e.clientId?.lastName ?? ""
                              : e.lawyerId?.lastName ?? "",
                          image: !isLawyer ? e.lawyerId?.profileImg ?? "" : "",
                          status: e.serviceStatus ?? "",
                          profession: isLawyer ? 'Үйлчлүүлэгч' : "Хуульч"));
                }).toList(),
              ),
            )),
          ),
        ));
  }
}
