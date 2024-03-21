import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_app/my_theme.dart';

class CustomElevatedButton extends StatelessWidget {
  bool enable;

  void Function()? onPressed;

  String buttonText;

  CustomElevatedButton(
      {required this.enable,
      required this.onPressed,
      super.key,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalization = AppLocalizations.of(context)!;
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * .11,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor:
                  enable ? MyTheme.primaryColor : MyTheme.whiteColor),
          onPressed: enable ? onPressed : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                buttonText,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    color: enable ? MyTheme.whiteColor : MyTheme.greyColor,
                    fontFamily: "Inter-Regular"),
              ),
              Icon(
                Icons.arrow_forward,
                color: enable ? MyTheme.whiteColor : MyTheme.greyColor,
                size: 40,
              )
            ],
          )),
    );
  }
}
