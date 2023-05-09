import 'package:flutter/material.dart';
import 'package:frontend/shared/constants/index.dart';

class PrimeAppBar extends StatelessWidget with PreferredSizeWidget {
  PrimeAppBar(
      {super.key,
      required this.title,
      this.titleMargin = 0.0,
      this.hasLeading = true,
      this.hasLogo = true,
      this.paddingBottom = 12.0,
      this.wallet = false,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.settings = false,
      required this.onTap});
  final String title;
  final bool hasLeading;
  final bool settings;
  final double paddingBottom;
  final bool hasLogo;
  final bool wallet;
  final double titleMargin;
  final MainAxisAlignment mainAxisAlignment;
  final Function() onTap;
  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        width: double.infinity,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        padding:
            const EdgeInsets.symmetric(horizontal: origin, vertical: origin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: onTap,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: primary,
                )),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(
              width: huge,
            )
          ],
        ));
  }
}
