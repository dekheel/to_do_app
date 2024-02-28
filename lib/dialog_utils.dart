import 'package:flutter/material.dart';
import 'package:to_do_app/my_theme.dart';

class DialogUtils {
  static showLoading(
      {required BuildContext context,
      required String loadingMessage,
      bool isDismissible = false}) {
    showDialog(
      barrierDismissible: isDismissible,
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircularProgressIndicator(
                  color: MyTheme.primaryColor, strokeWidth: 5),
              const SizedBox(
                width: 20,
              ),
              Text(loadingMessage,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: MyTheme.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))
            ],
          ),
        );
      },
    );
  }

  static hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static showMessage(
      {required BuildContext context,
      String? title,
      bool isDismissible = true,
      required String content,
      String? posActions,
      Function(BuildContext)? posFunction,
      String? negActions,
      Function(BuildContext)? negFunction}) {
    List<Widget> actions = [];

    if (posActions != null) {
      actions.add(TextButton(
          onPressed: () {
            if (posFunction != null) {
              posFunction.call(context);
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            posActions,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold, color: MyTheme.primaryColor),
          )));
    }

    if (negActions != null) {
      actions.add(TextButton(
          onPressed: () {
            if (negFunction != null) {
              negFunction.call(context);
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            negActions,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold, color: MyTheme.primaryColor),
          )));
    }

    showDialog(
      barrierDismissible: isDismissible,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 0,
          title: title != null
              ? Text(
                  title ?? "",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: MyTheme.blackColor, fontWeight: FontWeight.bold),
                )
              : null,
          content: Text(
            content,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: MyTheme.blackColor),
          ),
          actions: actions.isEmpty ? null : actions,
        );
      },
    );
  }
}
