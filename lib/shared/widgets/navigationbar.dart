import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/modules/modules.dart';
import 'package:get/get.dart';

import '../../shared/index.dart';

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({super.key});
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    return Obx(() => NavigationBar(
          selectedIndex: homeController.currentIndex.value,
          onDestinationSelected: (value) =>
              homeController.changeNavIndex(value),
          destinations: homeController.currentUserType.value == 'lawyer' ||
                  homeController.currentUserType.value == 'our'
              ? lawyerNavbar.map((e) {
                  NavigationDestination body;
                  body = NavigationDestination(
                    icon: SvgPicture.asset(
                      e['icon']!,
                    ),
                    selectedIcon: SvgPicture.asset(e['activeIcon']!),
                    label: e['label']!,
                  );
                  // }

                  return body;
                }).toList()
              : userNavbar.map((e) {
                  NavigationDestination body;
                  body = NavigationDestination(
                    icon: SvgPicture.asset(e['icon']!),
                    selectedIcon: SvgPicture.asset(e['activeIcon']!),
                    label: e['label']!,
                  );
                  // }

                  return body;
                }).toList(),
        ));
  }
}
