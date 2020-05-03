import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkour_app/Widgets/drawer.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/support/router.gr.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _result;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_result == CodeStrings.resultPasswordChangeSuccess) {
        _showSnackBar(
            AppStrings.passwordChangedMessage, CodeStrings.typeSuccess);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _checkPassedArguments();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            MainRouter.navigator.pushNamed(MainRouter.placeSubmissionPage),
        child: Icon(
          Icons.add,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      key: _scaffoldKey,
      drawer: MainDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 40.0, left: 20.0),
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
              icon: Icon(
                Icons.menu,
                color: AppColors.black,
                size: 30.0,
              ),
            ),
          ),
          Spacer(),
          Text(
            '<Map will be shown here>',
            style: TextStyle(
                color: Colors.green,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
        ],
      ),
    );
  }

  void _checkPassedArguments() {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    if (args != null) {
      setState(() {
        _result = args['result'];
      });
    }
  }

  void _showSnackBar(String message, String type) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
                type == CodeStrings.typeError
                    ? Icons.warning
                    : Icons.check_circle,
                color: type == CodeStrings.typeError
                    ? AppColors.white
                    : Colors.lightGreen),
            SizedBox(
              width: 8.0,
            ),
            Text(
              message,
              style: TextStyle(
                  color: type == CodeStrings.typeError
                      ? AppColors.white
                      : Colors.lightGreen),
            ),
          ],
        ),
      ),
    );
  }
}
