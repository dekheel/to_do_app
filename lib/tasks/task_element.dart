import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/provider/app_config_provider.dart';
import 'package:to_do_app/tasks/edit_task.dart';

class TaskElement extends StatelessWidget {
  final Task task;

  const TaskElement({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    Size screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, EditTask.routeName, arguments: task);
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Slidable(
          // The start action pane is the one at the left or the top side.
          startActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                borderRadius: BorderRadius.circular(20),
                onPressed: (context) {},
                backgroundColor: MyTheme.redColor,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),

          child: Container(
            height: screenSize.height * .13,
            decoration: BoxDecoration(
              color: provider.isDarkMode()
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
                  color: Theme.of(context).primaryColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          task.taskTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20),
                          child: Text(
                            "${task.taskDate.day}/"
                            "${task.taskDate.month}/"
                            "${task.taskDate.year}",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 12,
                                    color: provider.isDarkMode()
                                        ? MyTheme.whiteColor
                                        : MyTheme.blackColor,
                                    fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
