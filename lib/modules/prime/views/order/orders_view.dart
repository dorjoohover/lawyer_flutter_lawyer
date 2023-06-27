import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/modules/prime/views/maps.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../shared/index.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key, required this.isLawyer});
  final bool isLawyer;
  @override
  State<OrdersView> createState() => _OrdersViewState();
}

final controller = Get.put(PrimeController());

class _OrdersViewState extends State<OrdersView> {
  @override
  void initState() {
    start();
    super.initState();
  }

  start() async {
    await controller.getOrderList(widget.isLawyer);
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          controller.getOrderList(widget.isLawyer);
        },
        child: Container(
            padding: const EdgeInsets.only(
                bottom: large, right: origin, left: origin),
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: AnimationLimiter(
                  child: Obx(() => Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 1000),
                          childAnimationBuilder: (p0) => SlideAnimation(
                              verticalOffset: 50,
                              child: FadeInAnimation(
                                child: p0,
                              )),
                          children: controller.orders.isNotEmpty
                              ? controller.orders.map((e) {
                                  return Container(
                                      margin:
                                          const EdgeInsets.only(bottom: origin),
                                      child: OrderDetailView(
                                          onTap: () async {
                                            if (e.serviceType == 'online' ||
                                                e.serviceType ==
                                                    'onlineEmergency') {
                                              homeController.getChannelToken(
                                                  e, widget.isLawyer, '');
                                            } else {
                                              homeController.loading.value =
                                                  true;
                                              if (e.serviceType ==
                                                  'fulfilled') {
                                                Get.to(() => OrderTrackingPage(
                                                    isLawyer: false,
                                                    location: e.location ??
                                                        LocationDto(
                                                            lat: 0.0,
                                                            lng: 0.0)));
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    createRoute(
                                                        UserOrderMapPageView(
                                                            lawyerId: e
                                                                .lawyerId!.sId!,
                                                            location: e
                                                                    .location ??
                                                                LocationDto(
                                                                    lat: 0.0,
                                                                    lng:
                                                                        0.0))));
                                              }
                                              homeController.loading.value =
                                                  false;
                                            }
                                          },
                                          date: DateFormat('yyyy/MM/dd').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  e.date!)),
                                          time: DateFormat('hh:mm').format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      e.date!)),
                                          type: e.serviceType ?? "",
                                          name: widget.isLawyer
                                              ? e.clientId?.lastName ?? ""
                                              : e.lawyerId?.lastName ?? "",
                                          image: !widget.isLawyer
                                              ? e.lawyerId?.profileImg ?? ""
                                              : "",
                                          status: e.serviceStatus ?? "",
                                          profession: widget.isLawyer
                                              ? 'Үйлчлүүлэгч'
                                              : "Хуульч"));
                                }).toList()
                              : [
                                  space24,
                                  const Icon(
                                    Icons.search,
                                    color: secondary,
                                    size: 24,
                                  ),
                                  space16,
                                  Text(
                                    'Одоогоор захиалга байхгүй байна',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(color: secondary),
                                  ),
                                ],
                        ),
                      ))),
            )),
      ),
    );
  }
}
