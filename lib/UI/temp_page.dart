import 'package:flutter/material.dart';
import 'package:parkour_app/resources/colors.dart';

class TempPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '<Content will be shown here>',
          style: TextStyle(
              color: AppColors.offGrey,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
