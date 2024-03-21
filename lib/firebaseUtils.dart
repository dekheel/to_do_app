import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/dialog_utils.dart';
import 'package:to_do_app/home/home_screen.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/model/user_model.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/provider/tasks_provider.dart';
import 'package:to_do_app/provider/user_provider.dart';

class FirebaseUtils {
  // get tasks collection reference
  static CollectionReference<Task> getTasksCollection(String uid) {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .doc(uid)
        .collection(Task.taskCollection)
        .withConverter<Task>(
            fromFirestore: (snapshot, _) => Task.fromFirebase(snapshot.data()!),
            toFirestore: (task, _) => task.toFirebase());
  }

  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
            fromFirestore: (snapshot, options) =>
                MyUser.fromFirestore(snapshot.data()),
            toFirestore: (user, _) => user.toFirestore());
  }

  static Future<void> addUserToFirestore(MyUser user) {
    return getUsersCollection().doc(user.id).set(user);
  }

  // add task object to firestore
  static Future addNewTaskToFirestore(
      Task task, String uid, BuildContext context) async {
    AppLocalizations? appLocalization = AppLocalizations.of(context);
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);

    DialogUtils.showLoading(
        context: context, loadingMessage: appLocalization!.adding_task_load);
    await Future.delayed(const Duration(seconds: 2));

    CollectionReference<Task> taskCollection = getTasksCollection(uid);
    DocumentReference<Task> docRef = taskCollection.doc();
    task.id = docRef.id;

    docRef.set(task);
  }

  // delete task object from firestore

  static Future<void> deleteTaskFromFirebase(Task task, String uid) {
    return getTasksCollection(uid).doc(task.id).delete();
  }

  static Future<void> updateTaskOnFirebase(Task task, String uid) {
    return getTasksCollection(uid).doc(task.id).update(task.toFirebase());
  }

  static Future<void> finishTaskOnFirebase(String id, String uid) {
    return getTasksCollection(uid).doc(id).update({"isDone": true});
  }

  static Future<void> addUserOnFirebase(String emailAddress, String password,
      String name, BuildContext context) async {
    AppLocalizations appLocalization = AppLocalizations.of(context)!;
    DialogUtils.showLoading(
        context: context, loadingMessage: appLocalization.signing_in);
    await Future.delayed(const Duration(seconds: 2));

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      MyUser user = MyUser(
          id: credential.user?.uid ?? "", name: name, email: emailAddress);

      await addUserToFirestore(user);

      var user_provider = Provider.of<AuthProviders>(context, listen: false);
      user_provider.updateUser(user);

      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (Route<dynamic> route) => false);

      Fluttertoast.showToast(
        msg: "√ ${appLocalization.signed_up_success}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: MyTheme.greenColor,
        textColor: MyTheme.blackDarkColor,
        fontSize: 16.0,
      );
    } catch (e) {
      DialogUtils.hideLoading(context);
      DialogUtils.showMessage(
          context: context,
          content: e.toString(),
          title: appLocalization.error_word,
          posActions: appLocalization.ok);
    }
  }

  // static Future<void> signInFirebase(
  //     String emailAddress, String password, BuildContext context) async {
  //   AppLocalizations appLocalization = AppLocalizations.of(context)!;
  //   var user_provider = Provider.of<AuthProviders>(context, listen: false);
  //
  //   DialogUtils.showLoading(
  //       context: context, loadingMessage: appLocalization.signing_in);
  //
  //   await Future.delayed(const Duration(seconds: 2));
  //   try {
  //     final credential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: emailAddress, password: password);
  //     DialogUtils.hideLoading(context);
  //
  //     var user = await readUserFromFirestore(credential.user!.uid);
  //
  //     user_provider.updateUser(user);
  //
  //     if (user == null) {
  //       return;
  //     }
  //
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, HomeScreen.routeName, (Route<dynamic> route) => false);
  //
  //     var app_provider = Provider.of<AppConfigProvider>(context, listen: false);
  //
  //     app_provider.changeEmail(emailAddress);
  //
  //     Fluttertoast.showToast(
  //       msg: "√ ${appLocalization.logged_in_success}",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.SNACKBAR,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: MyTheme.greenColor,
  //       textColor: MyTheme.blackDarkColor,
  //       fontSize: 16.0,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     DialogUtils.hideLoading(context);
  //
  //     if (e.code == 'invalid-credential') {
  //       DialogUtils.showMessage(
  //           context: context,
  //           content: e.code,
  //           title: appLocalization.error_word,
  //           posActions: appLocalization.ok);
  //     }
  //   } catch (e) {
  //     DialogUtils.hideLoading(context);
  //     DialogUtils.showMessage(context: context, content: e.toString());
  //   }
  // }

  static Future<void> ResetPassFirebase(
      String emailAddress, BuildContext context) async {
    AppLocalizations appLocalization = AppLocalizations.of(context)!;

    DialogUtils.showLoading(
        context: context, loadingMessage: appLocalization.resetting_loading);
    await Future.delayed(const Duration(seconds: 2));

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailAddress)
          .onError((error, stackTrace) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context: context, content: error.toString());
      });

      DialogUtils.hideLoading(context);
      Navigator.of(context).pop();

      Fluttertoast.showToast(
        msg: "√ ${appLocalization.resetting_message}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: MyTheme.greenColor,
        textColor: MyTheme.blackDarkColor,
        fontSize: 16.0,
      );
    } catch (error) {
      DialogUtils.hideLoading(context);
      DialogUtils.showMessage(context: context, content: error.toString());
    }
  }

  static Future<MyUser?> readUserFromFirestore(String uid) async {
    var querySnapshot = await getUsersCollection().doc(uid).get();

    return querySnapshot.data();
  }
}
