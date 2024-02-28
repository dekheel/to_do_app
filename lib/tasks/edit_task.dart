import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebaseUtils.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/provider/app_config_provider.dart';
import 'package:to_do_app/provider/tasks_provider.dart';
import 'package:to_do_app/provider/user_provider.dart';

class EditTask extends StatefulWidget {
  static String routeName = "edit_task";

  const EditTask({super.key});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  FocusNode titleFocus = FocusNode();
  FocusNode detailFocus = FocusNode();

  var formKey = GlobalKey<FormState>();
  late AppConfigProvider appconfigProvider;
  late TaskProvider taskProvider;
  late AuthProviders? authProvider;

  late Task args;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)?.settings.arguments as Task;
    appconfigProvider = Provider.of<AppConfigProvider>(context);
    taskProvider = Provider.of<TaskProvider>(context);
    authProvider = Provider.of<AuthProviders>(context);
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(appLocalizations!.to_do_list_app_bar),
          toolbarHeight: MediaQuery.of(context).size.height * .12),
      body: Form(
        key: formKey,
        child: Container(
          height: MediaQuery.of(context).size.height * .65,
          margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
          decoration: BoxDecoration(
              color: appconfigProvider.isDarkMode()
                  ? MyTheme.blackColor
                  : MyTheme.whiteColor,
              borderRadius: BorderRadius.circular(25)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      appLocalizations.edit_task,
                      style: appconfigProvider.isDarkMode()
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return appLocalizations.error_task_title;
                      }
                      return null;
                    },
                    controller: TextEditingController(text: args.title),
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: appconfigProvider.isDarkMode()
                                  ? MyTheme.whiteColor
                                  : MyTheme.greyColor),
                        ),
                        hintStyle: appconfigProvider.isDarkMode()
                            ? Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: MyTheme.whiteColor, fontSize: 20)
                            : Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: MyTheme.blackColor, fontSize: 20)),
                    maxLines: 1,
                    focusNode: titleFocus,
                    onChanged: (value) {
                      args.title = value;
                    },
                    style: appconfigProvider.isDarkMode()
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return appLocalizations.error_task_details;
                      }
                      return null;
                    },
                    controller: TextEditingController(text: args.details),
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: appconfigProvider.isDarkMode()
                                  ? MyTheme.whiteColor
                                  : MyTheme.greyColor),
                        ),
                        hintStyle: appconfigProvider.isDarkMode()
                            ? Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: MyTheme.whiteColor, fontSize: 20)
                            : Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: MyTheme.blackColor, fontSize: 20)),
                    maxLines: 4,
                    focusNode: detailFocus,
                    onChanged: (value) {
                      args.details = value;
                    },
                    style: appconfigProvider.isDarkMode()
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    appLocalizations.select_date,
                    textAlign: TextAlign.start,
                    style: appconfigProvider.isDarkMode()
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        selectDate();
                      },
                      child: Text(
                        "${args.date?.year}/${args.date?.month}/${args.date?.day}",
                        textAlign: TextAlign.start,
                        style: appconfigProvider.isDarkMode()
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
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: CheckboxListTile(
                    title: Text(
                      args.isDone == true
                          ? appLocalizations.done_task
                          : appLocalizations.no_done_task,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: appconfigProvider.isDarkMode()
                              ? MyTheme.whiteColor
                              : MyTheme.blackColor),
                    ),
                    value: args.isDone,
                    tileColor: MyTheme.primaryColor,
                    onChanged: (newValue) {
                      setState(() {
                        args.isDone = newValue;
                      });
                    },
                    side: BorderSide(
                        color: appconfigProvider.isDarkMode()
                            ? MyTheme.whiteColor
                            : MyTheme.blackColor),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                    onPressed: () {
                      editTask(args);
                    },
                    child: Text(
                      appLocalizations.save_button,
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

    args.date = selectedDate ?? args.date;
    setState(() {});
  }

  void editTask(Task task) {
    if (formKey.currentState?.validate() == true) {
      FirebaseUtils.updateTaskOnFirebase(task, authProvider!.currentUser!.id!);
      taskProvider.getAllFirebaseTasks(authProvider!.currentUser!.id!);
      Navigator.of(context).pop();
    }
  }
}
