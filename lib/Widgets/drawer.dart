import 'package:parkour_app/bloc/auth/auth_bloc.dart';
import 'package:parkour_app/bloc/auth/auth_event.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChaiDrawer extends StatelessWidget {
  AuthBloc _authBloc = GetIt.instance<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 200.0,
              color: AppColors.primaryColor,
            ),
            InkWell(
              onTap: () => _authBloc.dispatch(UserLogoutRequested()),
              child: ListTile(
                leading: Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
