import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class ClientRatingWidget extends GetView<PrimeController> {
  const ClientRatingWidget({
    super.key,
    required this.ratings,
  });

  final List<Rating> ratings;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(origin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(origin), color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Хэрэглэгчдийн үнэлгээ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: ratings.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: origin),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ratings[index].clientId ?? "",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            space8,
                            Text(
                              ratings[index].comment ?? "",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        )),
                    Expanded(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: gold,
                            ),
                            space8,
                            Text(
                              ratings[index].rating.toString(),
                              style: Theme.of(context).textTheme.labelMedium,
                            )
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
