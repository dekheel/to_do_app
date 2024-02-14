import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/provider/app_config_provider.dart';

class ShowThemeBottomSheet extends StatelessWidget {
  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              provider.changeTheme(ThemeMode.light);
            },
            child: provider.isDarkMode()
                ? getUnSelectedItemLanguage(
                    context, AppLocalizations.of(context)!.light_mode)
                : getSelectedItemLanguage(
                    context, AppLocalizations.of(context)!.light_mode),
          ),
          const SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              provider.changeTheme(ThemeMode.dark);
            },
            child: provider.isDarkMode()
                ? getSelectedItemLanguage(
                    context, AppLocalizations.of(context)!.dark_mode)
                : getUnSelectedItemLanguage(
                    context, AppLocalizations.of(context)!.dark_mode),
          ),
        ],
      ),
    );
  }

  Widget getSelectedItemLanguage(BuildContext context, String theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(theme,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold)),
        Icon(
          Icons.check,
          size: 35,
          color: Theme.of(context).primaryColor,
        )
      ],
    );
  }

  Widget getUnSelectedItemLanguage(BuildContext context, String theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(theme,
            style: provider.isDarkMode()
                ? Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: MyTheme.whiteColor)
                : Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
