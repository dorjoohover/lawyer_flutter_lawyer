import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/modules/modules.dart';

import '../../shared/index.dart';

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({super.key, required this.homeController});
  final HomeController homeController;
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: homeController.currentIndex.value,
      onDestinationSelected: (value) => homeController.changeNavIndex(value),
      destinations: homeController.user?.userType == 'lawyer'
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
    );
  }
}
