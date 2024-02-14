import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebaseUtils.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/provider/app_config_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  String? taskTitle;
  String? taskDetails;

  DateTime taskDate = DateTime.now();

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
                onChanged: (value) {
                  taskTitle = value;
                },
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
                onChanged: (value) {
                  taskDetails = value;
                },
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
                    "${taskDate.year}/${taskDate.month}/${taskDate.day}",
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

    taskDate = selectedDate ?? taskDate;

    setState(() {});
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      FirebaseUtils.addTaskToFirestore(
              Task(title: taskTitle, details: taskDetails, date: taskDate))
          .timeout(
        const Duration(milliseconds: 500),
        onTimeout: () {},
      );
      Navigator.of(context).pop();

      // show snackBar
      // ScaffoldMessenger.of(context).showSnackBar(showSnackbar(taskTitle));

      // show Toast
      // showToast(taskTitle);

      // show alert dialog
      // _showMyDialog(taskTitle);
    }
  }

// void showToast(String? taskTitle) {
//   Fluttertoast.showToast(
//       msg: "√ $taskTitle is added successfully",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: MyTheme.backgroundDarkColor,
//       textColor: Colors.white,
//       fontSize: 16.0);
// }

// SnackBar showSnackbar(String? taskTitle) {
//   return SnackBar(
//     content: Text("√ $taskTitle is added successfully"),
//     backgroundColor: MyTheme.backgroundDarkColor,
//     duration: const Duration(milliseconds: 1000),
//   );
// }

// Future<void> _showMyDialog(String? taskTitle) async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false, // user must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text(
//           'Success',
//           textAlign: TextAlign.center,
//         ),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[
//               Text("√ $taskTitle is added successfully"),
//             ],
//           ),
//         ),
//         alignment: Alignment.center,
//         actionsAlignment: MainAxisAlignment.center,
//         actions: <Widget>[
//           ElevatedButton(
//             child: const Text(
//               'Ok',
//               textAlign: TextAlign.center,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
}
