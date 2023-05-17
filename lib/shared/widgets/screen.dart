import 'package:flutter/material.dart';
import 'package:frontend/shared/index.dart';

class Screen extends StatelessWidget {
  const Screen(
      {Key? key,
      required this.title,
      required this.children,
      this.isScroll = true,
      this.resize = true,
      required this.child})
      : super(
          key: key,
        );
  final String title;
  final List<Widget> children;
  final Widget child;
  final bool isScroll;
  final bool resize;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: resize,
        appBar: PrimeAppBar(
            onTap: () {
              Navigator.of(context).pop();
            },
            title: title),
        backgroundColor: bg,
        body: Container(
          padding: const EdgeInsets.only(left: origin, right: origin),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: isScroll ? const NeverScrollableScrollPhysics() : null,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children),
              ),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 50,
                  left: 0,
                  right: 0,
                  child: child)
            ],
          ),
        ));
  }
}
