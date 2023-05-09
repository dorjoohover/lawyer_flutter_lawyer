import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:frontend/modules/emergency/widgets/emergency_card.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';

class EmergencyHomeView extends StatefulWidget {
  const EmergencyHomeView({super.key});

  @override
  State<EmergencyHomeView> createState() => _EmergencyHomeViewState();
}

class _EmergencyHomeViewState extends State<EmergencyHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: MainAppBar(
        title: 'Яаралтай',
      ),
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: () async {
              // await controller.start();
            },
            child: Container(
              color: bg,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                  left: origin, top: origin, right: origin),
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
                    const EmergencyCard(
                      expiredTime: 10,
                      price: 10000,
                      icon: Icons.phone,
                      title: 'Яаралтай дуудлага хийж  хуулийн зөвлөгөө авах',
                    ),
                    space16,
                    const EmergencyCard(
                      expiredTime: 30,
                      price: 100000,
                      icon: Icons.person,
                      title: 'Хуульч дуудаж хууль зүйн туслалцаа авах',
                    ),
                  ],
                ),
              )))),
            )),
      ),
    );
  }
}
