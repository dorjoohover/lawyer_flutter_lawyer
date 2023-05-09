import 'package:flutter/material.dart';
import 'package:frontend/shared/index.dart';

class DirectionView extends StatelessWidget {
  const DirectionView({super.key, required this.list});
  final List<String> list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrimeAppBar(
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Дэлгэрэнгүй'),
        backgroundColor: bg,
        body: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: origin,
              right: origin),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  space32,
                  const Text(
                    'Заавар',
                    style: TextStyle(fontSize: 25, color: primary),
                  ),
                  Column(
                    children: list.map((e) {
                      int i = list.indexOf(e);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${i + 1}',
                              style: const TextStyle(color: gold, fontSize: 39),
                            ),
                            const SizedBox(
                              width: 11,
                            ),
                            Text(
                              e,
                              style: Theme.of(context).textTheme.displayMedium,
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 50,
                  left: 0,
                  right: 0,
                  child: MainButton(
                    onPressed: () {
                      // controller.sendOrder(context);
                    },
                    text: "Үргэлжлүүлэх",
                    child: const SizedBox(),
                  ))
            ],
          ),
        ));
  }
}
