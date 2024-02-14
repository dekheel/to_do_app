import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/provider/app_config_provider.dart';
import 'package:to_do_app/tasks/task_element.dart';

class ToDoList extends StatelessWidget {
  const ToDoList({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 17.0),
      child: Column(
        children: [
          EasyDateTimeLine(
            timeLineProps: const EasyTimeLineProps(separatorPadding: 12),
            locale: provider.appLanguage,
            initialDate: DateTime.now(),
            onDateChange: (selectedDate) {
              //`selectedDate` the new date selected.
            },
            headerProps: EasyHeaderProps(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                showSelectedDate: true,
                monthStyle: provider.isDarkMode()
                    ? Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: MyTheme.whiteColor)
                    : Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: MyTheme.blackColor),
                monthPickerType: MonthPickerType.dropDown,
                dateFormatter: const DateFormatter.fullDateDMonthAsStrY(),
                showMonthPicker: true,
                // monthPickerType: MonthPickerType.dropDown,
                showHeader: true,
                selectedDateStyle: provider.isDarkMode()
                    ? Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: MyTheme.whiteColor)
                    : Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: MyTheme.blackColor)),
            dayProps: EasyDayProps(
              todayStyle: DayStyle(
                  dayNumStyle: provider.isDarkMode()
                      ? Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: MyTheme.blackColor)
                      : Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: MyTheme.blackColor,
                          ),
                  dayStrStyle: provider.isDarkMode()
                      ? Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: MyTheme.blackColor)
                      : Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: MyTheme.blackColor,
                          ),
                  decoration: BoxDecoration(
                    color: MyTheme.greenColor,
                    borderRadius: BorderRadius.circular(10),
                  )),
              dayStructure: DayStructure.dayStrDayNum,
              height: 90,
              inactiveDayStyle: DayStyle(
                dayNumStyle: provider.isDarkMode()
                    ? Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: MyTheme.whiteColor)
                    : Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: MyTheme.blackColor,
                        ),
                dayStrStyle: provider.isDarkMode()
                    ? Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: MyTheme.whiteColor)
                    : Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: MyTheme.blackColor),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: provider.isDarkMode()
                        ? MyTheme.blackColor
                        : MyTheme.whiteColor),
              ),
              activeDayStyle: DayStyle(
                dayNumStyle: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: MyTheme.whiteColor),
                dayStrStyle: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: MyTheme.whiteColor),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: MyTheme.primaryColor),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return TaskElement(
                    task: Task(
                        taskDate: DateTime.now().add(Duration(days: index)),
                        taskDetails: "${(index + 1) * 11111111111}",
                        taskTitle: "Play Football ${index + 1}"));
              },
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
