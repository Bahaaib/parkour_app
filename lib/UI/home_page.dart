import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkour_app/support/router.gr.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Home Page',
              style: TextStyle(color: Colors.green,
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                MainRouter.navigator.pushNamedAndRemoveUntil(
                    MainRouter.loginPage, (_) => false);
              },
              child: Text(
                'Log out',
                style: TextStyle(color: Colors.red,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
