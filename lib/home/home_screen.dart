import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/authentication/login/login.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/provider/app_config_provider.dart';
import 'package:to_do_app/provider/tasks_provider.dart';
import 'package:to_do_app/provider/user_provider.dart';
import 'package:to_do_app/tasks/add_task.dart';
import 'package:to_do_app/tasks/task_list_body.dart';

import '../settings/setting_tab.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "homeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  late AppLocalizations? _appLocalizations;

  String appBarTitle = '';

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context);
    var provider = Provider.of<AppConfigProvider>(context);
    var user_provider = Provider.of<AuthProviders>(context);
    var task_provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: appBarTitle.isEmpty
            ? Text("${_appLocalizations!.to_do_list_app_bar}${{
                user_provider.currentUser!.name
              }}")
            : Text(appBarTitle),
        toolbarHeight: MediaQuery.of(context).size.height * .12,
        actions: [
          IconButton(
              onPressed: () {
                user_provider.currentUser = null;
                task_provider.taskList = [];
                Navigator.of(context).pushReplacementNamed(LogIn.routeName);
              },
              icon: Icon(
                Icons.logout,
                color: provider.isDarkTheme
                    ? MyTheme.blackDarkColor
                    : MyTheme.whiteColor,
              ))
        ],
      ),
      body: selectedIndex == 0 ? const ToDoList() : const SettingsTab(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color:
            provider.isDarkMode() ? MyTheme.blackDarkColor : MyTheme.whiteColor,
        child: BottomNavigationBar(
          onTap: (index) {
            selectedIndex = index;
            if (selectedIndex == 0) {
              appBarTitle = "${_appLocalizations!.to_do_list_app_bar}${{
                user_provider.currentUser!.name
              }}";
              // _appLocalizations!.to_do_list_app_bar;
            } else {
              appBarTitle = _appLocalizations!.settings_app_bar;
            }
            setState(() {});
          },
          currentIndex: selectedIndex,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.list),
                label: _appLocalizations!.to_do_list_app_bar),
            BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: _appLocalizations!.settings_app_bar)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTaskBottomSheet();
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const FractionallySizedBox(
              heightFactor: 0.54, child: AddTaskBottomSheet()),
        );
      },
    );
  }
}
