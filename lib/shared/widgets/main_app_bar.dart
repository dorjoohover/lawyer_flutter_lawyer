import 'package:flutter/material.dart';
import 'package:frontend/shared/constants/index.dart';

const double kToolbarHeight = 76.0;

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  MainAppBar({
    super.key,
    required this.title,
    this.titleMargin = 0.0,
    this.hasLeading = true,
    this.hasLogo = true,
    this.paddingBottom = 12.0,
    this.wallet = false,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.settings = false,
  });
  final String title;
  final bool hasLeading;
  final bool settings;
  final double paddingBottom;
  final bool hasLogo;
  final bool wallet;
  final double titleMargin;
  final MainAxisAlignment mainAxisAlignment;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  // final authCtrl = Get.find<HomeController>();
  // final splshcntrl = Get.find<SplashController>();
  // final walletConroller = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + origin),
      padding: const EdgeInsets.symmetric(horizontal: origin),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xffcfcfcf)))),
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
                children: [IconButton(onPressed: () {}, icon: SvgPicture)],
              )
            ],
          ),
        ],
      ),
    );
  }
}
