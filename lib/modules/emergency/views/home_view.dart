import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:frontend/modules/emergency/widgets/emergency_card.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class EmergencyHomeView extends StatefulWidget {
  const EmergencyHomeView({super.key});

  @override
  State<EmergencyHomeView> createState() => _EmergencyHomeViewState();
}

class _EmergencyHomeViewState extends State<EmergencyHomeView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmergencyController());
    return SafeArea(
      child: RefreshIndicator(
          onRefresh: () async {
            // await controller.start();
          },
          child: Container(
            color: bg,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
                child: EmergencyAnimationContainer(
                    child: AnimationLimiter(
                        child: Column(
              children: AnimationConfiguration.toStaggeredList(
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  EmergencyCard(
                    expiredTime: 10,
                    onTap: () {
                      controller.serviceType.value = 'onlineEmergency';
                      Navigator.push(
                          context,
                          createRoute(DirectionView(
                            list: onlineDirection,
                          )));
                    },
                    price: 10000,
                    icon: Icons.phone,
                    title: 'Яаралтай дуудлага хийж  хуулийн зөвлөгөө авах',
                  ),
                  space16,
                  EmergencyCard(
                    onTap: () {
                      controller.serviceType.value = 'fulfilledEmergency';
                      Navigator.push(
                          context,
                          createRoute(DirectionView(
                            list: fulfilledDirection,
                          )));
                    },
                    expiredTime: 60,
                    price: 100000,
                    icon: Icons.person,
                    title: 'Хуульч дуудаж хууль зүйн туслалцаа авах',
                  ),
                ],
              ),
            )))),
          )),
    );
  }
}
