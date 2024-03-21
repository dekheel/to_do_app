import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/authentication/login/login_abstract_navigator.dart';
import 'package:to_do_app/firebaseUtils.dart';

class LoginViewModel extends ChangeNotifier {
  // todo: hold data

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  bool showValidEmailIcon = false;

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode userEmailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  late LoginNavigator loginNavigator;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//  todo: handle logic

  void checkEmailValidation(String value) {
    // check for email
    if (emailValid.hasMatch(value)) {
      showValidEmailIcon = true;
    } else {
      showValidEmailIcon = false;
    }
    notifyListeners();
  }

  void getEmailFromSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailTextController.text = prefs.getString("userEmail") ?? "";
  }

  Future<void> logIn() async {
    if (formKey.currentState?.validate() == true) {
      loginNavigator
          .showLoadingSignIn(loginNavigator.appLocalizationSigningIn());

      await Future.delayed(const Duration(seconds: 2));
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailTextController.text,
                password: passwordController.text);

        loginNavigator.hideLoading();

        var user =
            await FirebaseUtils.readUserFromFirestore(credential.user!.uid);

        loginNavigator.updateUserEmail(user, emailTextController.text);

        if (user == null) {
          return;
        }

        loginNavigator.pushNamedAndRemoveUntilLogin();

        loginNavigator
            .showToast(loginNavigator.appLocalizationLoggedInSuccess());
      } on FirebaseAuthException catch (e) {
        loginNavigator.hideLoading();

        if (e.code == 'invalid-credential') {
          loginNavigator.showMessage(
              message: e.code,
              title: loginNavigator.appLocalizationErrorWord(),
              posAction: loginNavigator.appLocalizationOk());
        }
      } catch (e) {
        loginNavigator.hideLoading();

        loginNavigator.showMessage(message: e.toString());
      }
    }
  }

  bool checkTextField() {
    if (emailTextController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty || emailValid.hasMatch(value) == false) {
      return loginNavigator.appLocalizationErrorEmail();
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return loginNavigator.appLocalizationErrorPassword();
    }
    return null;
  }

  Future getuserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userEmail = prefs.getString("userEmail") ?? "";
    emailTextController = TextEditingController(text: userEmail);
    notifyListeners();
  }
}
