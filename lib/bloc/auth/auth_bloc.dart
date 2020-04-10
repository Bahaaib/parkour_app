import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkour_app/bloc/auth/bloc.dart';
import 'package:parkour_app/bloc/bloc.dart';

import 'package:rxdart/rxdart.dart';

class AuthBloc extends BLoC<AuthEvent> {
  PublishSubject authSubject = PublishSubject<AuthState>();


  @override
  void dispatch(AuthEvent event) async {
    if (event is LoginWithGoogleRequested) {
      _loginWithGoogle();
    }



    if(event is UserLogoutRequested){
    }
  }


  Future<void> _loginWithGoogle() async {
    print('login with google is tapped');
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      var user = await _googleSignIn.signIn();
      if (user != null) {
        print(user.email);

      }
    } catch (error) {
      print(error);
    }
  }


  ///Extracts the white spaces out of string
  String _getCleanString(String value) {
    return value.trim();
  }

  void dispose() {
    authSubject.close();
  }
}
