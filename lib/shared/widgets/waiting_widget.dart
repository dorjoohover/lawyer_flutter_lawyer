import 'package:flutter/material.dart';

import '../../shared/index.dart';

class WaitingChannelWidget extends StatelessWidget {
  const WaitingChannelWidget({super.key, required this.isLawyer});
  final bool isLawyer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timelapse, size: 80),
              space64,
              Text(
                '${isLawyer ? 'Хэрэглэгч' : 'хуульч'} орж иртэл',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 24),
              ),
              Text(
                'Түр хүлээнэ үү',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 24),
              )
            ],
          )),
    );
  }
}
