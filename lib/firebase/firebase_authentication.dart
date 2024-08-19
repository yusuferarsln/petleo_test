import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuthentication get auth => FirebaseAuthentication.instance;

class FirebaseAuthentication {
  FirebaseAuthentication._();
  static final FirebaseAuthentication instance = FirebaseAuthentication._();

  Future<int> authLogin(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("Sign-ineee");
      print(userCredential);
      return 0; // Successful login
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 1;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 2;
      } else {
        print('FirebaseAuthException: ${e.message}');
        return 3;
      }
    } catch (e) {
      print('General exception: $e');
      return 4;
    }
  }

  authSignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  authRegister(String email, String password, String username) async {
    print("ss");

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      print(userCredential);

      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid);

      DocumentSnapshot userDoc = await userDocRef.get();
      await userDocRef.set({
        'userId': userCredential.user!.uid,
        'userName': username ?? 'Unknown User',
      });
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> authForgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      final error = e.toString();
      String errorCode = error.split("/")[1].split("]")[0];
      print("*********** $errorCode");
      if (errorCode == "user-not-found") {
        return "user-not-found";
      } else {
        return "unknown";
      }
    }
    return "sended";
  }

  authCheck<bool>() async {
    var currentUserX = FirebaseAuth.instance.currentUser;

    if (currentUserX == null) {
      print('user not lign');
      return false;
    } else {
      print('user logged');
      return true;
    }
  }

  String authFuuid() {
    var currentUserX = FirebaseAuth.instance.currentUser;
    return currentUserX!.uid;
  }
}
