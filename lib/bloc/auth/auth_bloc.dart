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
import 'package:parkour_app/support/router.gr.dart';

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
      await _loginWithGoogle();
    }

    if (event is LoginWithEmailAndPasswordRequested) {
      await _loginWithEMailAndPassword(event.email, event.password);
    }

    if (event is SignUpWithEmailAndPasswordRequested) {
      await _signUpWithEmailAndPassword(event.email, event.password);
    }

    if (event is UserCurrentStatusRequested) {
      await _getCurrentUser();
    }

    if (event is UserPasswordResetRequested) {
      await _resetPassword(event.email);
    }

    if (event is UserDataByCachedIdRequested) {
      await _getUserById();
    }

    if (event is UserLogoutRequested) {
      await _logout();
    }
  }

  Future<void> _loginWithEMailAndPassword(String email, String password) async {
    showLoadingDialog();
    FirebaseUser user;
    await _firebaseAuth
        .signInWithEmailAndPassword(
            email: _getCleanString(email), password: password)
        .then((result) async {
      user = result.user;
      await _getUserDataByEmail(email);
      hideLoadingDialog();
    }).catchError((error) {
      print(error.toString());
      authSubject.add(UserIsLoggedIn(null));
      hideLoadingDialog();
    });

    _addKeyInPreferences(user.uid);
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
    FirebaseUser user;
    await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: _getCleanString(email), password: password)
        .then((result) {
      user = result.user;

      _createUserInDatabase(email, user.uid);
      authSubject.add(UserIsRegisteredWithEmailAndPassword(true));
      _firebaseAuth.signOut();
      hideLoadingDialog();
    }).catchError((error) {
      authSubject.add(UserIsRegisteredWithEmailAndPassword(false));
      hideLoadingDialog();
    });

  }

  Future<void> _createUserInDatabase(String email, String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child(CodeStrings.databaseDevInstance)
        .child(CodeStrings.usersDatabaseRef)
        .push();
    ref.set({
      'id': uid,
      'email_address': email,
    });
  }

  Future<void> _addKeyInPreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(CodeStrings.userSharedPrefKEY, key);
  }

  Future<String> _getUserIdFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(CodeStrings.userSharedPrefKEY);
  }

  Future<void> _removeKeyFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(CodeStrings.userSharedPrefKEY);
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

  Future<void> _getUserById() async {
    String uid = await _getUserIdFromPreferences();
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
        if (user.id == uid) {
          print('USER ==> ${user.id}');
          _userProvider.user = user;
          break;
        }
      }
      authSubject.add(UserDataIsFetched());
    });
  }

  Future<void> _getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    authSubject.add(CurrentUserIs(user));
  }

  Future<void> _resetPassword(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email).then((_) {
      authSubject.add(PasswordIsReset(true));
    }).catchError((_) {
      authSubject.add(PasswordIsReset(false));
    });
  }

  Future<void> _logout() async {
    FirebaseAuth.instance.signOut();
    _removeKeyFromPreferences();
    MainRouter.navigator
        .pushNamedAndRemoveUntil(MainRouter.loginPage, (_) => false);
  }

  ///Extracts the white spaces out of string
  String _getCleanString(String value) {
    return value.trim();
  }

  void dispose() {
    authSubject.close();
  }
}
