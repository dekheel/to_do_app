import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/provider/app_config_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime date = DateTime.now();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalization = AppLocalizations.of(context);
    var provider = Provider.of<AppConfigProvider>(context);

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  appLocalization!.add_task,
                  style: provider.isDarkMode()
                      ? Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: MyTheme.whiteColor)
                      : Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: MyTheme.blackColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalization.error_task_title;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: provider.isDarkMode()
                              ? MyTheme.whiteColor
                              : MyTheme.greyColor),
                    ),
                    hintText: appLocalization.task_title,
                    hintStyle: provider.isDarkMode()
                        ? Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: MyTheme.whiteColor, fontSize: 20)
                        : Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: MyTheme.greyColor, fontSize: 20)),
                maxLines: 1,
                focusNode: FocusNode(),
                onChanged: (value) {},
                style: provider.isDarkMode()
                    ? Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: MyTheme.whiteColor)
                    : Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: MyTheme.blackColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalization.error_task_details;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: provider.isDarkMode()
                              ? MyTheme.whiteColor
                              : MyTheme.greyColor),
                    ),
                    hintText: appLocalization.task_details,
                    hintStyle: provider.isDarkMode()
                        ? Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: MyTheme.whiteColor, fontSize: 20)
                        : Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: MyTheme.greyColor, fontSize: 20)),
                maxLines: 4,
                focusNode: FocusNode(),
                onChanged: (value) {},
                style: provider.isDarkMode()
                    ? Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: MyTheme.whiteColor)
                        ?.copyWith(color: MyTheme.whiteColor)
                    : Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: MyTheme.blackColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                appLocalization.select_date,
                textAlign: TextAlign.start,
                style: provider.isDarkMode()
                    ? Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: MyTheme.whiteColor, fontFamily: "Inter-Regular")
                    : Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: MyTheme.blackColor, fontFamily: "Inter-Regular"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Center(
                child: InkWell(
                  onTap: () {
                    selectDate();
                  },
                  child: Text(
                    "${date.year}/${date.month}/${date.day}",
                    textAlign: TextAlign.start,
                    style: provider.isDarkMode()
                        ? Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: MyTheme.whiteColor,
                            fontSize: 18,
                            fontFamily: "Inter-Regular")
                        : Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: MyTheme.blackColor,
                            fontSize: 18,
                            fontFamily: "Inter-Regular"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: ElevatedButton(
                onPressed: () {
                  addTask();
                },
                child: Text(
                  appLocalization.add_button,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      color: MyTheme.whiteColor,
                      fontFamily: "Inter-Regular"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  selectDate() async {
    var selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));

    date = selectedDate ?? date;
    setState(() {});
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {}
  }
}
