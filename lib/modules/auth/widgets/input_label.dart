import 'package:flutter/material.dart';
import 'package:frontend/modules/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../../../../../shared/constants/colors.dart';

class Input extends GetView<AuthController> {
  const Input(
      {super.key,
      this.onChange,
      this.textInputAction = TextInputAction.done,
      required this.labelText,
      this.tController,
      this.obscureText = false,
      this.suffixIcon,
      this.validator,
      this.onSubmitted,
      this.focusNode,
      this.textInputType = TextInputType.text});
  final void Function(String)? onChange;
  final String labelText;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextEditingController? tController;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmitted,
      autofocus: true,
      textInputAction: textInputAction,
      // focusNode: focusNode ?? focusNode,
      enableSuggestions: false,
      obscureText: obscureText,

      keyboardType: textInputType,
      style: Theme.of(context).textTheme.displayMedium,

      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: error),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: line),
        ),
        suffixIcon: suffixIcon ?? suffixIcon,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        // labelText: labelText,
        hintText: labelText,
        errorMaxLines: 2,
        hintStyle:
            Theme.of(context).textTheme.displayMedium!.copyWith(color: gray),
      ),
      controller: tController ?? tController,
      validator: validator ?? validator,
      onChanged: onChange,
    );
  }
}
