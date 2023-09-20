import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/lawyer/lawyer.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class CaseView extends StatefulWidget {
  const CaseView({super.key});

  @override
  State<CaseView> createState() => _CaseViewState();
}

final caseKey = GlobalKey<FormState>();

class _CaseViewState extends State<CaseView> {
  List<Experiences> exps = [];
  bool caseView = false;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LawyerRegisterController());
    return Screen(
        step: 7,
        isScroll: false,
        title: 'Шийдсэн хэрэг',
        children: Form(
          key: caseKey,
          child: Column(
            children: [
              Text(
                'Өөрийн шийдсэн хэргээ оруулна уу.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              space32,
              Obx(() => Column(
                    children: controller.decidedCase.map((d) {
                      if (!exps.contains(d)) {
                        exps.add(d);
                      }
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: small),
                        child: DecidedWidget(
                          date: d.date!,
                          title: d.title!,
                          onDate: (p0) => {
                            d.date = p0,
                            caseView = d.date !=
                                    DateTime.now().millisecondsSinceEpoch &&
                                d.link != '' &&
                                d.title != '',
                            check(controller)
                          },
                          onLink: (p0) => {
                            d.link = p0 ?? '',
                            caseView = d.date !=
                                    DateTime.now().millisecondsSinceEpoch &&
                                d.link != '' &&
                                d.title != '',
                            check(controller)
                          },
                          onTitle: (p0) => {
                            d.title = p0 ?? '',
                            caseView = d.date !=
                                    DateTime.now().millisecondsSinceEpoch &&
                                d.link != '' &&
                                d.title != '',
                            check(controller)
                          },
                          link: d.link!,
                        ),
                      );
                    }).toList(),
                  )),
              space16,
              InputButton(
                  onPressed: () {
                    controller.decidedCase.add(Experiences(
                        title: '',
                        date: DateTime.now().millisecondsSinceEpoch,
                        link: ''));
                    setState(() {
                      caseView = false;
                    });
                  },
                  icon: Icons.abc,
                  text: 'Өөр хэрэг нэмэх'),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom + 120,
              ),
            ],
          ),
        ),
        child: Obx(() => MainButton(
              view: caseView,
              onPressed: () {
                Navigator.push(context, createRoute(const AccountView()));
              },
              disabled: !controller.decided.value,
              text: "Үргэлжлүүлэх",
              child: const SizedBox(),
            )));
  }

  void check(LawyerRegisterController controller) {
    if (controller.decidedCase.first.title != '' &&
        controller.decidedCase.first.date != null &&
        controller.decidedCase.first.link != '') {
      controller.decided.value = true;
    } else {
      controller.decided.value = false;
    }
  }
}
