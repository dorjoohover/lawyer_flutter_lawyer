import 'package:flutter/material.dart';
import 'package:frontend/shared/index.dart';
import 'package:intl/intl.dart';

class EmergencyCard extends StatelessWidget {
  const EmergencyCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.expiredTime,
      required this.price});
  final IconData icon;
  final String title;
  final int price;
  final int expiredTime;
  @override
  Widget build(BuildContext context) {
    final oCcy = NumberFormat("₮ #,##0", "en_US");
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: primary,
        onTap: () {},
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Icon(
                icon,
                size: 50,
                color: gold,
              ),
              space32,
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white),
              ),
              space32,
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Дуудлагын хөлс',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Colors.white),
                      ),
                      space8,
                      Text(
                        '${oCcy.format(price)} төгрөг - $expiredTime мин',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Colors.white),
                      ),
                      MainButton(
                          onPressed: () {}, child: const Text('Төлбөр төлөх'))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
