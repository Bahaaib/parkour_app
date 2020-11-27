import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/bloc/auth/auth_bloc.dart';
import 'package:parkour_app/bloc/auth/bloc.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/support/router.gr.dart';
import 'package:firebase_admob/firebase_admob.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    _streamSubscription = _authBloc.authSubject.listen((receivedState) {
      if (receivedState is CurrentUserIs) {
        if (receivedState.user != null) {
          _authBloc.dispatch(UserDataByCachedIdRequested());
        } else {
          MainRouter.navigator
              .pushNamedAndRemoveUntil(MainRouter.loginPage, (_) => false);
        }
      }

      if (receivedState is UserDataIsFetched) {
        MainRouter.navigator
            .pushNamedAndRemoveUntil(MainRouter.homePage, (_) => false);
      }
    });
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    Future.delayed(Duration(seconds: 3)).then((_) {
      _authBloc.dispatch(UserCurrentStatusRequested());
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,
      body: Center(
        child: Container(
          width: 300.0,
          height: 300.0,
          child: Image.asset(
            CodeStrings.splashLogo,
            color: AppColors.primaryColor,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
