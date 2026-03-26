import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseProvider>(context);

    if (provider.loading) {
      provider.getUserData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                provider.logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => LoginScreen()));
              }),
        ],
      ),
      body: Center(
        child: provider.loading
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.name, style: TextStyle(fontSize: 22)),
            SizedBox(height: 10),
            Text(provider.email, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}