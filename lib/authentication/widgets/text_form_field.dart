import 'package:flutter/material.dart';
import 'package:to_do_app/my_theme.dart';

class CustomTextFormField extends StatefulWidget {
  String? Function(String?)? validator;
  bool showEmailSuffixIcon;
  FocusNode focusNode;

  bool obscureText;

  TextEditingController controller;

  void Function(String)? onChanged;
  String label;
  TextInputType keyboardType;

  CustomTextFormField({
    required this.onChanged,
    required this.label,
    required this.controller,
    required this.validator,
    required this.focusNode,
    this.obscureText = true,
    required this.keyboardType,
    this.showEmailSuffixIcon = true,
    super.key,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    // AppLocalizations appLocalization = AppLocalizations.of(context)!;

    return TextFormField(
        validator: widget.validator,
        decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.redColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.redColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.primaryColor, width: 2),
            ),
            suffixIcon: widget.keyboardType == TextInputType.emailAddress
                ? Icon(Icons.check_circle,
                    color: widget.showEmailSuffixIcon
                        ? MyTheme.primaryColor
                        : MyTheme.whiteColor)
                : widget.keyboardType == TextInputType.number
                    ? IconButton(
                        onPressed: () {
                          widget.obscureText = !widget.obscureText;
                          setState(() {});
                        },
                        icon: Icon(widget.obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        color: MyTheme.primaryColor)
                    : null,
            label: Text(widget.label),

            // appLocalization.e_mail
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.primaryColor, width: 2),
            ),
            hintStyle: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: MyTheme.whiteColor, fontSize: 20)),
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        maxLines: 1,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: Colors.black));
  }
}
