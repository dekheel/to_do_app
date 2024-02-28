import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoTask extends StatelessWidget {
  const NoTask({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalization = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            appLocalization!.no_tasks,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 30,
                ),
          ),
          Icon(
            Icons.arrow_downward_outlined,
            size: 150,
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
