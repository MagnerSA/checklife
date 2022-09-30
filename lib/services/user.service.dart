import 'package:cloud_firestore/cloud_firestore.dart';

// import '../models/user.model.dart' as UserModel;
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore bd = FirebaseFirestore.instance;

  Future<bool> isUserLogged() async {
    var user = auth.currentUser;

    return user != null;
  }

  String currentUserID() {
    User user = auth.currentUser as User;

    return user.uid;
  }

  Future<bool> login(String email, String password) async {
    bool isLogged = true;

    print(email);
    print(password);
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((_) {})
        .catchError((error) {
      isLogged = false;
    });

    return isLogged;
  }

  logout() async {
    await auth.signOut();
  }
}
