import 'package:flutter/cupertino.dart';
import 'package:to_do_app/model/user_model.dart';

class AuthProviders extends ChangeNotifier {
  MyUser? currentUser;

  void updateUser(MyUser? newUser) {
    currentUser = newUser;
    notifyListeners();
  }
}
