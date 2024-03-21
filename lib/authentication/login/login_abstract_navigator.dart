import 'package:to_do_app/model/user_model.dart';

abstract class LoginNavigator {
  //  todo: actions
  void showLoadingSignIn(String message);

  void showMessage({String message, String title, String posAction});

  void hideLoading();

  void pushNamedAndRemoveUntilLogin();

  void pushNamedSignup();

  void showToast(String message);

  String appLocalizationErrorEmail();

  String appLocalizationErrorPassword();

  String appLocalizationSigningIn();

  String appLocalizationLoggedInSuccess();

  String appLocalizationErrorWord();

  String appLocalizationOk();

  void updateUserEmail(MyUser? user, String email);
}
