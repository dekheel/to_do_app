import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/model/task_model.dart';

class FirebaseUtils {
  // get tasks collection reference
  static CollectionReference<Task> getTasksCollection() {
    return FirebaseFirestore.instance
        .collection(Task.taskCollection)
        .withConverter<Task>(
            fromFirestore: (snapshot, _) => Task.fromFirebase(snapshot.data()!),
            toFirestore: (task, _) => task.toFirebase());
  }

  // add task object to firestore
  static Future<void> addTaskToFirestore(Task task) {
    CollectionReference<Task> taskCollection = getTasksCollection();
    DocumentReference<Task> docRef = taskCollection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }
}
