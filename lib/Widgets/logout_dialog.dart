import 'package:flutter/material.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/resources/dimens.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/bloc/auth/bloc.dart';
import 'package:parkour_app/bloc/auth/auth_bloc.dart';
import 'package:parkour_app/bloc/auth/auth_event.dart';

class LogoutDialog extends StatefulWidget {
  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  AuthBloc _authBloc = GetIt.instance<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        margin: EdgeInsets.only(
            top: AppDimens.screenPadding,
            left: AppDimens.screenPadding,
            right: AppDimens.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              AppStrings.logout,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              AppStrings.logoutText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _authBloc.dispatch(UserLogoutRequested());
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: AppDimens.screenPadding, top: 10),
                    child: Text(
                      AppStrings.logout,
                      style: TextStyle(color: AppColors.red),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: AppDimens.screenPadding, top: 10),
                    child: Text(AppStrings.cancelLabel),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
