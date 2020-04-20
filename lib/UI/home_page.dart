import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkour_app/Widgets/drawer.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/support/router.gr.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 40.0, left: 20.0),
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: ()=> _scaffoldKey.currentState.openDrawer(),
              icon: Icon(
                Icons.menu,
                color: AppColors.black,
                size: 30.0,
              ),
            ),
          ),
          Text(
            'Home Page',
            style: TextStyle(
                color: Colors.green,
                fontSize: 50.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
