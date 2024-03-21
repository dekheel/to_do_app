import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_app/authentication/widgets/elevated_button.dart';
import 'package:to_do_app/authentication/widgets/text_form_field.dart';
import 'package:to_do_app/firebaseUtils.dart';
import 'package:to_do_app/my_theme.dart';

class ResetPassword extends StatefulWidget {
  static String routeName = "ResetPassword";

  ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  FocusNode userEmailFocusNode = FocusNode();

  bool showValidEmailIcon = false;

  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  TextEditingController emailController = TextEditingController();

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
                appLocalization.reset_password,
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
                  height: screenSize.height * .20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        controller: emailController,
                        focusNode: userEmailFocusNode,
                        showEmailSuffixIcon: showValidEmailIcon,
                      ),
                      SizedBox(
                        height: screenSize.height * .1,
                      ),
                      CustomElevatedButton(
                          enable: checkTextField(),
                          onPressed: () {
                            resetPassword(context);
                          },
                          buttonText: appLocalization.reset_password),
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

  bool checkTextField() {
    if (emailController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  void resetPassword(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      FirebaseUtils.ResetPassFirebase(emailController.text, context);
    }
  }
}
