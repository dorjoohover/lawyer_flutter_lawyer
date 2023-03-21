import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/shared/constants/index.dart';

const double kToolbarHeight = 76.0;

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  MainAppBar({
    super.key,
    required this.title,
    this.titleMargin = 0.0,
    this.hasLeading = true,
    this.calendar = false,
    this.paddingBottom = 12.0,
    this.wallet = false,
    this.settingTap,
    this.calendarTap,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.settings = false,
  });
  final String title;
  final bool hasLeading;
  final bool settings;
  final double paddingBottom;
  final bool calendar;
  final Function()? settingTap;
  final Function()? calendarTap;
  final bool wallet;
  final double titleMargin;
  final MainAxisAlignment mainAxisAlignment;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + origin),
      padding: const EdgeInsets.symmetric(horizontal: origin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  settings
                      ? IconButton(
                          onPressed: settingTap,
                          icon: SvgPicture.asset(svgSettings))
                      : const SizedBox(),
                  calendar
                      ? IconButton(
                          onPressed: calendarTap,
                          icon: SvgPicture.asset(svgCalendar))
                      : const SizedBox()
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
