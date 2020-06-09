import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:load/load.dart';
import 'package:parkour_app/bloc/auth/auth_state.dart';
import 'package:parkour_app/bloc/bloc.dart';
import 'package:parkour_app/bloc/profile/bloc.dart';
import 'package:parkour_app/provider/user_provider.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/support/router.gr.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc extends BLoC<ProfileEvent> {
  PublishSubject profileSubject = PublishSubject<AuthState>();
  final UserProvider _userProvider = GetIt.instance<UserProvider>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _usersDbRef = FirebaseDatabase.instance.reference();

  @override
  void dispatch(ProfileEvent event) {
    if (event is UserDataUpdateRequested) {
      _updateUserInfo(event.userData);
    }
  }

  Future<void> _updateUserInfo(Map<String, String> data) async {
    showLoadingDialog();

    _usersDbRef
        .child(CodeStrings.databaseDevInstance)
        .child(CodeStrings.usersDatabaseRef)
        .child(_userProvider.user.child_id)
        .update(data)
        .then((_) {
      hideLoadingDialog();
      MainRouter.navigator
          .pushNamedAndRemoveUntil(MainRouter.homePage, (route) => false);
    }).catchError((_) {
      hideLoadingDialog();
    });
  }

  void dispose() {
    profileSubject.close();
  }
}
