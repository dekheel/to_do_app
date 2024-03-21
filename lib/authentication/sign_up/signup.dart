import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_app/authentication/widgets/elevated_button.dart';
import 'package:to_do_app/authentication/widgets/text_form_field.dart';
import 'package:to_do_app/firebaseUtils.dart';
import 'package:to_do_app/my_theme.dart';

class SignUp extends StatefulWidget {
  static String routeName = "signUp";

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  FocusNode userNameFocusNode = FocusNode();

  FocusNode userEmailFocusNode = FocusNode();

  FocusNode password1FocusNode = FocusNode();
  FocusNode password2FocusNode = FocusNode();

  bool showValidEmailIcon = false;

  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  TextEditingController userNameController = TextEditingController(text: "");
  TextEditingController password1Controller = TextEditingController(text: "");
  TextEditingController password2Controller = TextEditingController(text: "");

  TextEditingController emailController = TextEditingController(text: "");

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
                appLocalization.sign_up,
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
              child: Column(
                children: [
                  SizedBox(
                    height: screenSize.height * .15,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                            obscureText: false,
                            onChanged: (value) {},
                            label: appLocalization.first_name,
                            controller: userNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return appLocalization.error_user_name;
                              }

                              return null;
                            },
                            focusNode: userNameFocusNode,
                            keyboardType: TextInputType.text),
                        SizedBox(
                          height: screenSize.height * .02,
                        ),
                        CustomTextFormField(
                          obscureText: false,
                          onChanged: (value) {
                            if (emailValid.hasMatch(value)) {
                              showValidEmailIcon = true;
                            } else {
                              showValidEmailIcon = false;
                            }

                            setState(() {});
                          },
                          label: appLocalization.e_mail,
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return appLocalization.error_email;
                            }
                            if (value.contains("@gmail.com") == false) {
                              return appLocalization.error_email;
                            }

                            return null;
                          },
                          focusNode: userEmailFocusNode,
                          keyboardType: TextInputType.emailAddress,
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
                          controller: password1Controller,
                          focusNode: password1FocusNode,
                        ),
                        SizedBox(
                          height: screenSize.height * .02,
                        ),
                        CustomTextFormField(
                          onChanged: (value) {},
                          keyboardType: TextInputType.number,
                          label: appLocalization.confirm_password,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return appLocalization.error_password;
                            } else if (value != password1Controller.text) {
                              return appLocalization.password_not_match;
                            }

                            return null;
                          },
                          controller: password2Controller,
                          focusNode: password2FocusNode,
                        ),
                        SizedBox(
                          height: screenSize.height * .02,
                        ),
                        CustomElevatedButton(
                          enable: checkTextField(),
                          onPressed: signUp,
                          buttonText: appLocalization.sign_up,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void signUp() {
    if (_formKey.currentState?.validate() == true) {
      FirebaseUtils.addUserOnFirebase(emailController.text,
          password1Controller.text, userNameController.text, context);
    }
  }

  bool checkTextField() {
    if (emailController.text.isNotEmpty &&
        password1Controller.text.isNotEmpty &&
        password2Controller.text.isNotEmpty &&
        userNameController.text.isNotEmpty) {
      return true;
    }
    return false;
  }
}
