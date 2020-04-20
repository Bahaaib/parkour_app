import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/bloc/auth/auth_bloc.dart';
import 'package:parkour_app/bloc/auth/bloc.dart';
import 'package:parkour_app/support/router.gr.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();

  @override
  void initState() {
    _authBloc.authSubject.listen((receivedState) {
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
      body: Center(
        child: Text(
          'Welcome',
          style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
