import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hints;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final IconData? iconData;
  final bool hide;
  final int? maxLines;
  final Widget trailing;
  final bool validate;
  final bool readonly;
  final Function(String value)? onChange;
  const CustomTextField({
    this.onChange,
    this.textInputType = TextInputType.name,
    this.textInputAction = TextInputAction.next,
    this.hide = false,
    this.maxLines,
    this.trailing = const SizedBox(),
    required this.controller,
    required this.hints,
    this.iconData,
    this.readonly = false,
    this.validate = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      shadowColor: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(30),
      child: TextFormField(
        onChanged: onChange,
        validator: (value) =>
            validate && controller.text.isEmpty ? "22".tr : null,
        readOnly: readonly,
        obscureText: hide,
        obscuringCharacter: "*",
        controller: controller,
        style: Theme.of(Get.context!).textTheme.titleSmall,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        maxLines: maxLines,
        cursorColor: Theme.of(context).colorScheme.primary,
        decoration: InputDecoration(
          labelText: hints,
          labelStyle: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Visibility(
            visible: iconData != null,
            child: Icon(
              iconData,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          suffix: trailing,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
        ),
      ),
    );
  }
}
