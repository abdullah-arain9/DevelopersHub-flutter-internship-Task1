import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider extends ChangeNotifier {
  String name = "";
  String email = "";
  bool loading = true;

  getUserData() async {
    loading = true;
    notifyListeners();

    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var data = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      name = data["name"];
      email = data["email"];
    }

    loading = false;
    notifyListeners();
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    name = "";
    email = "";
    notifyListeners();
  }
}