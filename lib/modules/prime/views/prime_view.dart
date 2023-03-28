import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/modules/auth/auth.dart';
import 'package:frontend/modules/home/controllers/controllers.dart';
import 'package:frontend/modules/prime/prime.dart';
import 'package:frontend/shared/index.dart';
import 'package:frontend/shared/widgets/order_detail.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PrimeView extends GetView<PrimeController> {
  const PrimeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrimeController());
    final lawyerController = Get.put(LawyerController());
    final homeController = Get.put(HomeController());
    final authController = Get.put(AuthController(apiRepository: Get.find()));
    final oCcy = NumberFormat("₮ #,##0", "en_US");
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: MainAppBar(
        title: 'Нүүр',
        calendar: true,
        settings: true,
        settingTap: () async {
          Get.to(() => LawyerRegisterView());
        },
        calendarTap: () async {
          await authController.logout();
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: () async {
              await controller.start();
            },
            child: Container(
              color: bg,
            height: defaultHeight(context),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(origin),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => MainLawyer(
                          bg: Colors.white,
                          experience:
                              homeController.user?.experience.toString() ?? '0',
                          name: homeController.user?.lastname ?? "",
                          profession: "Хуульч",
                          rating:
                              homeController.user?.ratingAvg.toString() ?? "0"),
                    ),
                    space16,
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(origin)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                        )),
                        space8,
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(origin)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                          ),
                        )
                      ],
                    ),
                    space16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Захиалгууд',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.getOrderList();
                          },
                          child: Text(
                            "Бүх захиалгууд",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        )
                      ],
                    ),
                    space16,
                    Obx(() => controller.orders.isNotEmpty
                        ? CarouselSlider(
                            options: CarouselOptions(
                                enableInfiniteScroll: false,
                                height: 200.0,
                                viewportFraction: 0.95,
                                padEnds: false),
                            items: controller.orders.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    margin: const EdgeInsets.only(right: small),
                                    child: OrderDetailView(
                                        onTap: () async {
                                          // await controller.getChannelToken(
                                          //     e.sId!, e.channelName!, e.serviceType!, context);
                                        },
                                        date: DateFormat('yyyy/MM/dd').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                i.date!)),
                                        time: DateFormat('hh:mm').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                i.date!)),
                                        type: i.serviceType ?? "",
                                        name: i.clientId?.lastname ?? "",
                                        status: i.serviceStatus ?? "pending",
                                        profession: 'Үйлчлүүлэгч'),
                                  );
                                },
                              );
                            }).toList(),
                          )
                        : const SizedBox()),
                    space32,
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LawyerAvailableDays(
                                          onPressed: () async {
                                            await lawyerController
                                                .addAvailableDays();
                                          },
                                        )));
                          },
                          child: const CardContainer(
                            value: 'Үйлчилгээний боломжит цаг тохируулах',
                            title: Icon(Icons.timelapse),
                          ),
                        )),
                        space16,
                        Expanded(
                            child: GestureDetector(
                          onTap: () {},
                          child: const CardContainer(
                            value: 'Үйлчилгээний боломжит цаг тохируулах',
                            title: Icon(Icons.lock_clock),
                          ),
                        )),
                      ],
                    ),
                    space16,
                    homeController.user?.rating != null
                        ? ClientRatingWidget(
                            ratings: homeController.user!.rating!)
                        : const SizedBox()
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
