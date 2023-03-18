import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/touchable_scale.dart';

import '../../shared/index.dart';

class MainButton extends StatelessWidget {
  const MainButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.text,
      this.contentColor,
      this.color = primary,
      this.width,
      this.padding = const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
      this.height = 56.0,
      this.borderRadius = 18.0,
      this.disabled = false,
      this.shadow = true,
      this.disabledColor = secondary})
      : super(key: key);
  final Widget child;
  final String? text;
  final Color color;
  final double? width;
  final Color? contentColor;
  final void Function() onPressed;
  final double height;
  final EdgeInsets padding;
  final double borderRadius;
  final bool disabled;
  final bool shadow;

  final Color disabledColor;

  @override
  Widget build(BuildContext context) {
    Color color = disabled ? disabledColor : this.color;

    final brightness = color.computeLuminance();
    final isDark = brightness < 0.6;
    Color contentColor = this.contentColor ?? Colors.white;

    Widget body = AnimatedContainer(
      height: height,
      width: width,
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
      child: Align(
        widthFactor: 1.0,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: contentColor,
            fontWeight: FontWeight.w500,
          ),
          child: IconTheme(
            data: Theme.of(context).iconTheme.copyWith(color: contentColor),
            child: text != null
                ? Text(
                    text!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                : child,
          ),
        ),
      ),
    );

    if (!disabled) body = TouchableScale(onPressed: onPressed, child: body);

    return Material(
      color: Colors.transparent,
      child: body,
    );
  }
}
