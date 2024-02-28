import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebaseUtils.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/provider/app_config_provider.dart';
import 'package:to_do_app/provider/tasks_provider.dart';
import 'package:to_do_app/provider/user_provider.dart';
import 'package:to_do_app/tasks/edit_task.dart';

class TaskElement extends StatefulWidget {
  final Task task;

  TaskElement({required this.task, super.key});

  @override
  State<TaskElement> createState() => _TaskElementState();
}

class _TaskElementState extends State<TaskElement> {
  late AppLocalizations? appLocalization;

  late AppConfigProvider appConfigProvider;
  late TaskProvider taskProvider;

  late AuthProviders? authProvider;

  @override
  Widget build(BuildContext context) {
    appConfigProvider = Provider.of<AppConfigProvider>(context);
    taskProvider = Provider.of<TaskProvider>(context);
    appLocalization = AppLocalizations.of(context);
    authProvider = Provider.of<AuthProviders>(context);

    Size screenSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(15),
      child: Slidable(
        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          extentRatio: 0.40,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(20),
              onPressed: (context) {
                FirebaseUtils.deleteTaskFromFirebase(
                        widget.task, authProvider!.currentUser!.id!)
                    .then((value) {
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(
                    msg:
                        "√ ${widget.task.title} ${appLocalization!.delete_task_snack_bar}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: MyTheme.redColor,
                    textColor: MyTheme.blackDarkColor,
                    fontSize: 16.0,
                  );

                  taskProvider
                      .getAllFirebaseTasks(authProvider!.currentUser!.id!);
                }).timeout(
                  const Duration(milliseconds: 500),
                  onTimeout: () {
                    Fluttertoast.showToast(
                      msg:
                          "√ ${widget.task.title} ${appLocalization!.delete_task_snack_bar}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      backgroundColor: MyTheme.redColor,
                      textColor: MyTheme.blackDarkColor,
                      fontSize: 16.0,
                    );

                    taskProvider
                        .getAllFirebaseTasks(authProvider!.currentUser!.id!);
                  },
                );
              },
              backgroundColor: MyTheme.redColor,
              icon: Icons.delete,
              label: appLocalization!.delete,
            ),
            SlidableAction(
              borderRadius: BorderRadius.circular(20),
              onPressed: (context) {
                Navigator.pushNamed(context, EditTask.routeName,
                    arguments: widget.task);
              },
              backgroundColor: MyTheme.greenColor,
              icon: Icons.edit,
              label: appLocalization!.edit,
              foregroundColor: MyTheme.blackDarkColor,
            ),
          ],
        ),

        child: Container(
          height: screenSize.height * .13,
          decoration: BoxDecoration(
            color: appConfigProvider.isDarkMode()
                ? MyTheme.blackColor
                : MyTheme.whiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                width: screenSize.width * .009,
                height: screenSize.height * .07,
                color: widget.task.isDone == false
                    ? Theme.of(context).primaryColor
                    : MyTheme.greenColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.task.title!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: widget.task.isDone == false
                                ? Theme.of(context).primaryColor
                                : MyTheme.greenColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: Text(
                          "${widget.task.date?.day}/"
                          "${widget.task.date?.month}/"
                          "${widget.task.date?.year}",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontSize: 12,
                                  color: appConfigProvider.isDarkMode()
                                      ? MyTheme.whiteColor
                                      : MyTheme.blackColor,
                                  fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              widget.task.isDone == false
                  ? InkWell(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        width: screenSize.width * .16,
                        height: screenSize.height * .05,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(
                          Icons.check,
                          color: MyTheme.whiteColor,
                          size: 40,
                        ),
                      ),
                      onTap: () {
                        FirebaseUtils.finishTaskOnFirebase(
                            widget.task.id!, authProvider!.currentUser!.id!);
                        taskProvider.getAllFirebaseTasks(
                            authProvider!.currentUser!.id!);
                      },
                    )
                  : Container(
                      margin: const EdgeInsets.all(20),
                      width: screenSize.width * .16,
                      height: screenSize.height * .05,
                      child: Text(
                        appLocalization!.done_task,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: MyTheme.greenColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
