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
  final int expiredTime;

  @override
  Widget build(BuildContext context) {
    final oCcy = NumberFormat("#,##0", "en_US");
    return Container(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width / 2 - medium),
      padding: const EdgeInsets.all(origin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(origin), color: primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              serviceTypes.firstWhere((t) => t['id'] == type)['value'] ?? "",
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: Colors.white,
                  ),
            ),
            fit: BoxFit.contain,
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
                '${expiredTime >= 60 ? expiredTime ~/ 60 : expiredTime} ${expiredTime >= 60 ? 'цаг' : 'мин'}',
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
