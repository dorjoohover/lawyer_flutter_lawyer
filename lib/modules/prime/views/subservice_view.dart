import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

import '../../../shared/index.dart';

class SubServiceView extends GetView<PrimeController> {
  const SubServiceView({
    super.key,
    required this.title,
    required this.description,
  });
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg,
        appBar: PrimeAppBar(
          title: 'Дэлгэрэнгүй',
          onTap: () {
            Get.to(() => const PrimeView());
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: large, horizontal: origin),
            height: MediaQuery.of(context).size.height - 76,
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              space32,
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              space16,
              Text(
                description,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              space32,
              Text(
                'Санал болгож буй хуульчид',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              space16,
              Expanded(
                  child: Obx(
                () => controller.loading.value
                    ? CircularProgressIndicator()
                    : ListView.builder(
                        itemCount: controller.lawyers.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                Get.to(() => PrimeLawyer(
                                      description:
                                          controller.lawyers[index].bio ?? '',
                                      experience: controller
                                          .lawyers[index].experience
                                          .toString(),
                                      name:
                                          controller.lawyers[index].lastname ??
                                              "",
                                      profession: 'Гэр бүлийн хуульч',
                                      rating: controller
                                          .lawyers[index].ratingAvg
                                          .toString(),
                                    ));
                              },
                              child: MainLawyer(
                                experience: controller.lawyers[index].experience
                                    .toString(),
                                name: controller.lawyers[index].lastname ?? "",
                                profession: 'Гэр бүлийн хуульч',
                                rating: controller.lawyers[index].ratingAvg
                                    .toString(),
                              ));
                        },
                      ),
              ))
            ]),
          ),
        ));
  }
}
