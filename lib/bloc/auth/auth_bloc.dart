
import 'package:google_sign_in/google_sign_in.dart';
import 'package:load/load.dart';
import 'package:parkour_app/bloc/auth/bloc.dart';
import 'package:parkour_app/bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:rxdart/rxdart.dart';

class AuthBloc extends BLoC<AuthEvent> {
  PublishSubject authSubject = PublishSubject<AuthState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void dispatch(AuthEvent event) async {
    if (event is LoginWithGoogleRequested) {
      _loginWithGoogle();
    }

    if (event is LoginWithEmailAndPasswordRequested) {
      _loginWithMailAndPassword(event.email, event.password);
    }

    if (event is UserLogoutRequested) {}
  }

  Future<void> _loginWithMailAndPassword(String email, String password) async {
    showLoadingDialog();

    await _firebaseAuth
        .signInWithEmailAndPassword(
            email: _getCleanString(email), password: password)
        .then((result) {
      FirebaseUser user = result.user;
      hideLoadingDialog();
    }).catchError((_) {
      authSubject.add(UserIsLoggedIn(null));
      hideLoadingDialog();
    });
  }

  Future<void> _loginWithGoogle() async {
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
        ///TODO: Get user data from DB
      } else {
        authSubject.add(UserIsLoggedIn(null));
      }
    } catch (error) {
      authSubject.add(UserIsLoggedIn(null));
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
