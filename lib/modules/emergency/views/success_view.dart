import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/shared/index.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key, required this.location});
  final String location;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: origin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            space32,
            Column(
              children: [
                SvgPicture.asset(
                  svgSuccess,
                  width: 96,
                ),
                space32,
                space16,
                Text(
                  "Амжилттай",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                space16,
                Text(
                  'Төлбөр амжилттай төлөгдлөө',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                space32,
                space4,
                Text(
                  'Байршил',
                  textAlign: TextAlign.center,
                ),
                Text(
                  location,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 50),
              width: double.infinity,
              child: MainButton(
                onPressed: () {},
                text: "Байршил харах",
                child: const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
