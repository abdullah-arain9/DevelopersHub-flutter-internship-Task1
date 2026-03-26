import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";
  bool loading = true;

  getUser() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var data =
      await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      setState(() {
        name = data["name"];
        email = data["email"];
        loading = false;
      });
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(onPressed: logout, icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: loading
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name, style: TextStyle(fontSize: 22)),
            SizedBox(height: 10),
            Text(email, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}