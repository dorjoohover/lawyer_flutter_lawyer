import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';

class LawyerView extends GetView<LawyerController> {
  const LawyerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerController());
    final primeController = Get.put(PrimeController());
    final homeController = Get.put(HomeController());
    final authController = Get.put(AuthController(apiRepository: Get.find()));
    final oCcy = NumberFormat("₮ #,##0", "en_US");
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: MainAppBar(
        title: 'Хуульч',
        calendar: false,
        settings: false,
        // settingTap: () async {
        //   if (homeController.currentUserType.value == 'user') {
        //     homeController.currentUserType.value = 'lawyer';
        //   } else {
        //     homeController.currentUserType.value = 'user';
        //   }
        //   homeController.getView(homeController.currentIndex.value);
        // },
      ),
      body: SafeArea(
          child: RefreshIndicator(
              onRefresh: () async {
                await controller.start();
              },
              child: Container(
                color: bg,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    left: origin, top: origin, right: origin),
                child: SingleChildScrollView(
                    child: LawyerAnimationContainer(
                  child: AnimationLimiter(
                    child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 375),
                            childAnimationBuilder: (widget) => SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: widget,
                                  ),
                                ),
                            children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MainLawyer(
                                bg: Colors.white,
                                user: homeController.user ?? User(),
                              ),
                              space16,
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(origin)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Энэ сарын орлого'),
                                          Text(
                                            oCcy.format(50000),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(color: success),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  space8,
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(origin)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Энэ сарын орлого'),
                                        Text(
                                          '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: primary),
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                              space16,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Захиалгууд',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      primeController.getOrderList(
                                          true, context);
                                    },
                                    child: Text(
                                      "Бүх захиалгууд",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                    ),
                                  )
                                ],
                              ),
                              space16,
                              Obx(() => primeController.orders.isNotEmpty &&
                                      !primeController.loading.value
                                  ? SizedBox(
                                      height: 216,
                                      child: AnimationLimiter(
                                        child: Column(
                                            children: AnimationConfiguration
                                                .toStaggeredList(
                                          duration:
                                              const Duration(milliseconds: 375),
                                          childAnimationBuilder: (widget) =>
                                              SlideAnimation(
                                            horizontalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: widget,
                                            ),
                                          ),
                                          children: [
                                            CarouselSlider(
                                              carouselController:
                                                  controller.carouselController,
                                              options: CarouselOptions(
                                                  enableInfiniteScroll: false,
                                                  height: 185.0,
                                                  viewportFraction: 0.95,
                                                  onPageChanged:
                                                      (index, reason) =>
                                                          controller
                                                              .currentOrder
                                                              .value = index,
                                                  padEnds: false),
                                              items: primeController.orders
                                                  .map((i) {
                                                return Builder(
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: small),
                                                      child: OrderDetailView(
                                                          onTap: () async {
                                                            controller
                                                                .getChannelToken(
                                                                    i,
                                                                    context,
                                                                    true,
                                                                    '');
                                                          },
                                                          date: DateFormat(
                                                                  'yyyy/MM/dd')
                                                              .format(DateTime
                                                                  .fromMillisecondsSinceEpoch(
                                                                      i.date!)),
                                                          time: DateFormat(
                                                                  'hh:mm')
                                                              .format(DateTime
                                                                  .fromMillisecondsSinceEpoch(
                                                                      i.date!)),
                                                          type: i.serviceType ??
                                                              "",
                                                          name: i.clientId
                                                                  ?.lastName ??
                                                              "",
                                                          image: '',
                                                          status:
                                                              i.serviceStatus ??
                                                                  "",
                                                          profession:
                                                              'Үйлчлүүлэгч'),
                                                    );
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: primeController.orders
                                                  .map((e) {
                                                final i = primeController.orders
                                                    .indexOf(e);
                                                return GestureDetector(
                                                    onTap: () => controller
                                                        .carouselController
                                                        .animateToPage(i),
                                                    child: Container(
                                                      width: 8.0,
                                                      height: 8.0,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 4.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: controller
                                                                    .currentOrder
                                                                    .value ==
                                                                i
                                                            ? gold
                                                            : line,
                                                      ),
                                                    ));
                                              }).toList(),
                                            ),
                                          ],
                                        )),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 200,
                                      child: SkeletonListView(),
                                    )),
                              homeController.user!.rating!.isNotEmpty
                                  ? space32
                                  : const SizedBox(),
                              homeController.user!.rating!.isNotEmpty
                                  ? ClientRatingWidget(
                                      ratings: homeController.user!.rating!)
                                  : const SizedBox(),
                              space16,
                              Row(
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     createRoute(
                                      //         const LawyerRegisterService()));
                                    },
                                    child: CardContainer(
                                      value:
                                          'Үйлчилгээний боломжит цаг тохируулах',
                                      title: SvgPicture.asset(svgClock),
                                    ),
                                  )),
                                  space16,
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      if (homeController
                                              .currentUserType.value ==
                                          'user') {
                                        homeController.currentUserType.value =
                                            'lawyer';
                                      } else {
                                        homeController.currentUserType.value =
                                            'user';
                                      }
                                      homeController.getView(
                                          homeController.currentIndex.value);
                                    },
                                    child: CardContainer(
                                      value: 'Хэрэглэгч цэс рүү буцах',
                                      title: SvgPicture.asset(svgRefresh),
                                    ),
                                    
                                  )),
                                ],
                              ),
                              space16
                            ],
                          ),
                        ])),
                  ),
                )),
              ))),
    );
  }
}
