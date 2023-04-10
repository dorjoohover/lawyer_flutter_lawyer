import 'package:flutter/material.dart';
import 'package:frontend/shared/index.dart';

class LawyerServiceWidget extends StatelessWidget {
  const LawyerServiceWidget(
      {super.key,
      required this.onPress,
      this.isBtn = true,
      this.submitText = 'Илгээх',
      required this.children});
  final bool isBtn;
  final Function() onPress;
  final List<Widget> children;
  final String submitText;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: children),
        isBtn
            ? Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 50,
                left: 0,
                right: 0,
                child: MainButton(
                  onPressed: onPress,
                  text: submitText,
                  child: const SizedBox(),
                ))
            : const SizedBox()
      ],
    );
  }
}
