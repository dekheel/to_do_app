import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/dialog_utils.dart';
import 'package:to_do_app/firebaseUtils.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/provider/app_config_provider.dart';
import 'package:to_do_app/provider/tasks_provider.dart';
import 'package:to_do_app/provider/user_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  String? taskTitle;
  String? taskDetails;
  late AppConfigProvider appConfigProvider;

  late TaskProvider taskProvider;

  late AppLocalizations? appLocalization;

  late AuthProviders? authProvider;

  DateTime taskDate = DateTime.now();

  FocusNode titleFocus = FocusNode();
  FocusNode detailFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    appLocalization = AppLocalizations.of(context);
    appConfigProvider = Provider.of<AppConfigProvider>(context);
    authProvider = Provider.of<AuthProviders>(context);
    taskProvider = Provider.of<TaskProvider>(context);
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
                  style: appConfigProvider.isDarkMode()
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
                    return appLocalization!.error_task_title;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appConfigProvider.isDarkMode()
                              ? MyTheme.whiteColor
                              : MyTheme.greyColor),
                    ),
                    hintText: appLocalization!.task_title,
                    hintStyle: appConfigProvider.isDarkMode()
                        ? Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: MyTheme.whiteColor, fontSize: 20)
                        : Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: MyTheme.greyColor, fontSize: 20)),
                maxLines: 1,
                focusNode: titleFocus,
                onChanged: (value) {
                  taskTitle = value;
                },
                style: appConfigProvider.isDarkMode()
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
                    return appLocalization!.error_task_details;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: appConfigProvider.isDarkMode()
                              ? MyTheme.whiteColor
                              : MyTheme.greyColor),
                    ),
                    hintText: appLocalization!.task_details,
                    hintStyle: appConfigProvider.isDarkMode()
                        ? Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: MyTheme.whiteColor, fontSize: 20)
                        : Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: MyTheme.greyColor, fontSize: 20)),
                maxLines: 4,
                focusNode: detailFocus,
                onChanged: (value) {
                  taskDetails = value;
                },
                style: appConfigProvider.isDarkMode()
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                appLocalization!.select_date,
                textAlign: TextAlign.start,
                style: appConfigProvider.isDarkMode()
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
                    "${taskDate.year}/${taskDate.month}/${taskDate.day}",
                    textAlign: TextAlign.start,
                    style: appConfigProvider.isDarkMode()
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
                  addTask(context);
                },
                child: Text(
                  appLocalization!.add_button,
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

    taskDate = selectedDate ?? taskDate;

    setState(() {});
  }

  void addTask(BuildContext context) {
    if (formKey.currentState?.validate() == true) {
      Task task = Task(title: taskTitle, details: taskDetails, date: taskDate);

      FirebaseUtils.addNewTaskToFirestore(
              Task(title: taskTitle, details: taskDetails, date: taskDate),
              authProvider!.currentUser!.id!,
              context)
          .then((value) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context: context,
            content: "${task.title} ${appLocalization!.adding_task_success}",
            title: appLocalization!.success,
            posActions: appLocalization!.ok,
            posFunction: (context) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              taskProvider.getAllFirebaseTasks(authProvider!.currentUser!.id!);
            });
      }).timeout(
        const Duration(milliseconds: 500),
        onTimeout: () {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context: context,
              content: "${task.title} ${appLocalization!.adding_task_success}",
              title: appLocalization!.success,
              posActions: appLocalization!.ok,
              posFunction: (context) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                taskProvider
                    .getAllFirebaseTasks(authProvider!.currentUser!.id!);
              });
        },
      );
    }
  }
}
