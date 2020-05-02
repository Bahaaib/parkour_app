import 'package:parkour_app/provider/user_provider.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/resources/dimens.dart';
import 'package:flutter/material.dart';
import 'package:parkour_app/support/router.gr.dart';
import 'package:parkour_app/Widgets/logout_dialog.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/bloc/auth/bloc.dart';
import 'package:parkour_app/bloc/auth/auth_bloc.dart';
import 'dart:async';

import 'logout_dialog.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String email = '';
  final UserProvider _userProvider = GetIt.instance<UserProvider>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                color: AppColors.primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                          top: 40.0, left: 20.0, bottom: 10.0),
                      width: 50.0,
                      height: 50.0,
                      child: CircleAvatar(
                        child: Text(
                          _userProvider.user.email_address
                              .substring(0, 2)
                              .toUpperCase(),
                          style: TextStyle(color: AppColors.white),
                        ),
                        backgroundColor: AppColors.accentColor,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Text(
                        _userProvider.user.email_address,
                        style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 8.0,
                        color: AppColors.primaryDarkColor,
                      ),
                    )
                  ],
                ),
              ),
              sectionHeader(AppStrings.account),
              menuOption(AppStrings.personalInfo,
                  () => navigate(MainRouter.profilePage)),
              menuOption(AppStrings.changePassword,
                  () => navigate(MainRouter.loginPage)),
              menuOption(AppStrings.myContributions,
                  () => navigate(MainRouter.contributionsPage)),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Divider(),
              ),
              sectionHeader(AppStrings.general),
              menuOption(AppStrings.privacyPolicy,
                  () => navigate(MainRouter.loginPage)),
              menuOption(AppStrings.termsAndConditions,
                  () => navigate(MainRouter.loginPage)),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Divider(),
              ),
              logout(context)
            ],
          ),
        ),
      ),
    );
  }

  void navigate(String route) {
    MainRouter.navigator.pushNamed(route);
  }

  Widget logout(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => LogoutDialog());
      },
      child: ListTile(
        leading: Text(
          AppStrings.logout,
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.red),
        ),
      ),
    );
  }

  Widget menuOption(String title, Function function) {
    return InkWell(
      onTap: function,
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String text) {
    return ListTile(
      leading: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w900, color: AppColors.primaryColor),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
