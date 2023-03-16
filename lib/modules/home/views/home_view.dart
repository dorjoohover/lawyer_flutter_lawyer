import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/agora.config.dart' as config;
import '../../../shared/index.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final controller = Get.put<HomeController>(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'APIExample',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: [
          Obx(() => ToggleButtons(
                color: Colors.grey[300],
                selectedColor: Colors.white,
                renderBorder: false,
                children: const [
                  Icon(
                    Icons.data_thresholding_outlined,
                  )
                ],
                isSelected: [controller.showPerformanceOverlay.value],
                onPressed: (index) {
                  controller.showPerformanceOverlay.value =
                      !controller.showPerformanceOverlay.value;
                },
              ))
        ],
      ),
      body: config.appId == ""
          ? const InvalidConfigWidget()
          : controller.getView(controller.currentIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.currentIndex,
        onDestinationSelected: (value) => controller.changeNavIndex(value),
        // labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: navBarIcons.map((e) {
          NavigationDestination body;
          body = NavigationDestination(
            icon: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xffA279cf),
                ),
                padding: const EdgeInsets.all(10),
                child: Text(e['label']!)),
            selectedIcon: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xff752394),
                ),
                padding: const EdgeInsets.all(10),
                child: Text(e['label']!)),
            label: e['label'] == 'Tiny' ? 'Discover' : e['label']!,
          );
          // }
          return body;
        }).toList(),
      ),
    );
  }
}

class InvalidConfigWidget extends StatelessWidget {
  /// Construct the [InvalidConfigWidget]
  const InvalidConfigWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Text(
          'Make sure you set the correct appId, ${config.appId}, channelId, etc.. in the lib/config/agora.config.dart file.'),
    );
  }
}
