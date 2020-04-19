import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:load/load.dart';
import 'package:parkour_app/PODO/AuthUser.dart';
import 'package:parkour_app/bloc/auth/bloc.dart';
import 'package:parkour_app/bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:parkour_app/provider/user_provider.dart';
import 'package:parkour_app/resources/strings.dart';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends BLoC<AuthEvent> {
  PublishSubject authSubject = PublishSubject<AuthState>();
  final UserProvider _userProvider = GetIt.instance<UserProvider>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _usersDbRef = FirebaseDatabase.instance.reference();

  @override
  void dispatch(AuthEvent event) async {
    if (event is LoginWithGoogleRequested) {
      _loginWithGoogle();
    }

    if (event is LoginWithEmailAndPasswordRequested) {
      _loginWithEMailAndPassword(event.email, event.password);
    }

    if (event is SignUpWithEmailAndPasswordRequested) {
      _signUpWithEmailAndPassword(event.email, event.password);
    }

    if (event is UserCurrentStatusRequested) {
      _getCurrentUser();
    }

    if(event is UserPasswordResetRequested){
      _resetPassword(event.email);
    }

    if (event is UserLogoutRequested) {}
  }

  Future<void> _loginWithEMailAndPassword(String email, String password) async {
    showLoadingDialog();

    await _firebaseAuth
        .signInWithEmailAndPassword(
            email: _getCleanString(email), password: password)
        .then((result) async {
      FirebaseUser user = result.user;
      await _getUserDataByEmail(email);
      hideLoadingDialog();
    }).catchError((error) {
      print(error.toString());
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

  Future<void> _signUpWithEmailAndPassword(
      String email, String password) async {
    showLoadingDialog();

    await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: _getCleanString(email), password: password)
        .then((result) {
      FirebaseUser user = result.user;

      _createUserInDatabase(email);
      authSubject.add(UserIsRegisteredWithEmailAndPassword(true));
      _firebaseAuth.signOut();
      hideLoadingDialog();
    }).catchError((error) {
      authSubject.add(UserIsRegisteredWithEmailAndPassword(false));
      hideLoadingDialog();
    });
  }

  Future<void> _createUserInDatabase(String email) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child(CodeStrings.databaseDevInstance)
        .child(CodeStrings.usersDatabaseRef)
        .push();
    ref.set({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'email_address': email,
    });

    _updateUserId(ref.key);
    _addKeyInPreferences(ref.key);
  }

  Future<void> _addKeyInPreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(CodeStrings.userSharedPrefKEY, key);
  }

  Future<void> _removeKeyFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(CodeStrings.userSharedPrefKEY);
  }

  Future<void> _updateUserId(String key) async {
    FirebaseDatabase.instance
        .reference()
        .child(CodeStrings.databaseDevInstance)
        .child(CodeStrings.usersDatabaseRef)
        .child(key)
        .update({'id': key});
  }

  Future<void> _getUserDataByEmail(String email) async {
    Map<dynamic, dynamic> children = {};
    List<AuthUser> users = [];

    _usersDbRef
        .child(CodeStrings.databaseDevInstance)
        .child(CodeStrings.usersDatabaseRef)
        .once()
        .then((DataSnapshot datasnapshot) {
      children = datasnapshot.value;

      children.forEach((key, value) {
        AuthUser user = AuthUser.firebaseUser(firebaseMap: value);
        users.add(user);
      });

      for (AuthUser user in users) {
        if (user.email_address == email) {
          print('USER ==> ${user.id}');
          _userProvider.user = user;
          break;
        }
      }
      authSubject.add(UserIsLoggedIn(_userProvider.user));
    });
  }

  Future<void> _getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    authSubject.add(CurrentUserIs(user));
  }

  Future<void> _resetPassword(String email)async{
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  ///Extracts the white spaces out of string
  String _getCleanString(String value) {
    return value.trim();
  }

  void dispose() {
    authSubject.close();
  }
}
