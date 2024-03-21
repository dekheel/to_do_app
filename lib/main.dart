import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/authentication/login/login.dart';
import 'package:to_do_app/authentication/reset_pass/reset.dart';
import 'package:to_do_app/authentication/sign_up/signup.dart';
import 'package:to_do_app/firebase_options.dart';
import 'package:to_do_app/home/home_screen.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/provider/app_config_provider.dart';
import 'package:to_do_app/provider/tasks_provider.dart';
import 'package:to_do_app/provider/user_provider.dart';
import 'package:to_do_app/tasks/edit_task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseFirestore.instance.disableNetwork();
  FirebaseFirestore.instance.settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isDarkTheme = prefs.getBool("isDark") ?? false;
  final bool isEnglish = prefs.getBool("isEnglish") ?? false;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => AppConfigProvider(isDarkTheme, isEnglish)),
      ChangeNotifierProvider(create: (_) => TaskProvider()),
      ChangeNotifierProvider(create: (_) => AuthProviders()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      themeMode: provider.appTheme,
      darkTheme: MyTheme.darkTheme,
      locale: Locale(provider.appLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: MyTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        EditTask.routeName: (context) => const EditTask(),
        LogIn.routeName: (context) => const LogIn(),
        SignUp.routeName: (context) => const SignUp(),
        ResetPassword.routeName: (context) => ResetPassword()
      },
      initialRoute: LogIn.routeName,
    );
  }
}
