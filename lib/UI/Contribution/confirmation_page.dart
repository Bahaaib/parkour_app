import 'package:flutter/material.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/support/router.gr.dart';

class ConfirmationPage extends StatefulWidget {
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage>
    with TickerProviderStateMixin {
  double _width;
  double _height;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _width = 250.0;
        _height = 250.0;
      });
    });
    _width = 100.0;
    _height = 100.0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 800),
            child: Container(
              width: _width,
              height: _height,
              child: Image.asset(CodeStrings.checkMarkIcon, fit: BoxFit.contain,),
            ),
          ),
          Text(
            AppStrings.contributionConfirmationMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, color: AppColors.green),
          ),
          _buildReturnButton(context)
        ],
      ),
    );
  }

  Widget _buildReturnButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70.0,
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      margin:
          EdgeInsetsDirectional.only(start: 20, end: 20, top: 30, bottom: 10),
      child: RaisedButton(
        color: AppColors.primaryColor,
        child: Text(
          'Return Home Page',
          style: TextStyle(
              color: AppColors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () => MainRouter.navigator
            .pushNamedAndRemoveUntil(MainRouter.homePage, (_) => false),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
