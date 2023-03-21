import 'package:flutter/material.dart';
import 'package:frontend/shared/index.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  const OrderCard(
      {super.key,
      required this.expiredTime,
      required this.price,
      required this.type});
  final String type;
  final double price;
  final String expiredTime;

  @override
  Widget build(BuildContext context) {
    final oCcy = NumberFormat("#,##0", "en_US");
    return Container(
      padding: const EdgeInsets.all(origin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(origin), color: primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Colors.white),
          ),
          space4,
          Text(
            '₮ ${oCcy.format(price)}',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          space8,
          Row(
            children: [
              const Icon(
                Icons.timer,
                color: Colors.white,
              ),
              space8,
              Text(
                '$expiredTime цаг',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}
