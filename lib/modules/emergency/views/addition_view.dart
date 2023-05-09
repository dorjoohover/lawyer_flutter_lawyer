import 'package:flutter/material.dart';
import 'package:frontend/modules/auth/auth.dart';
import 'package:frontend/shared/index.dart';

class AdditionView extends StatelessWidget {
  const AdditionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrimeAppBar(
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Нэмэлт мэдээлэл'),
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
                children: const [
                  space32,
                  Input(labelText: 'Уулзах шалтгаанаа бичиж оруулна уу')
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
                    text: "Төлбөр төлөх",
                    child: const SizedBox(),
                  ))
            ],
          ),
        ));
  }
}
