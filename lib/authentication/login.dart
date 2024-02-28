import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/authentication/elevated_button.dart';
import 'package:to_do_app/authentication/reset.dart';
import 'package:to_do_app/authentication/signup.dart';
import 'package:to_do_app/authentication/text_form_field.dart';
import 'package:to_do_app/firebaseUtils.dart';
import 'package:to_do_app/my_theme.dart';

class LogIn extends StatefulWidget {
  static String routeName = "LogIn";

  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailTextController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  Future getuserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userEmail = prefs.getString("userEmail") ?? "";
    emailTextController = TextEditingController(text: userEmail);
  }

  @override
  void initState() {
    getuserEmail();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  FocusNode userEmailFocusNode = FocusNode();

  FocusNode passwordFocusNode = FocusNode();

  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool showValidEmailIcon = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    AppLocalizations appLocalization = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Image(
            image: const AssetImage("assets/images/background.png"),
            width: screenSize.width,
            height: screenSize.height,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              toolbarHeight: 150,
              automaticallyImplyLeading: true,
              title: Text(
                appLocalization.log_in,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: MyTheme.whiteColor,
                    fontSize: 30,
                    fontFamily: "Poppins-Regular",
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: screenSize.height * .15,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalization.welcome,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: "Poppins-Regular",
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: screenSize.height * .02,
                      ),
                      CustomTextFormField(
                        obscureText: false,
                        onChanged: (value) {
                          // check for email
                          if (emailValid.hasMatch(value)) {
                            showValidEmailIcon = true;
                          } else {
                            showValidEmailIcon = false;
                          }
                          setState(() {});
                        },
                        label: appLocalization.e_mail,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              emailValid.hasMatch(value) == false) {
                            return appLocalization.error_email;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: emailTextController,
                        focusNode: userEmailFocusNode,
                        showEmailSuffixIcon: showValidEmailIcon,
                      ),
                      SizedBox(
                        height: screenSize.height * .02,
                      ),
                      CustomTextFormField(
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                        label: appLocalization.password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return appLocalization.error_password;
                          }
                          return null;
                        },
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                      ),
                      SizedBox(
                        height: screenSize.height * .02,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ResetPassword.routeName);
                        },
                        child: Text(
                          appLocalization.forget_password,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: MyTheme.blackColor,
                                  decoration: TextDecoration.underline),
                        ),
                      ),
                      CustomElevatedButton(
                          getColor: checkTextField(),
                          onPressed: logIn,
                          buttonText: appLocalization.log_in),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignUp.routeName);
                        },
                        child: Text(
                          appLocalization.create_new_account,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: MyTheme.blackColor,
                                  decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        )
      ],
    );
  }

  void logIn() {
    if (_formKey.currentState?.validate() == true) {
      FirebaseUtils.signInFirebase(
          emailTextController.text, passwordController.text, context);
    }
  }

  bool checkTextField() {
    if (emailTextController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      return true;
    }
    return false;
  }
}
