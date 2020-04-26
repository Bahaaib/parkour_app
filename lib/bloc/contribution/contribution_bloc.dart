import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/bloc/auth/auth_state.dart';
import 'package:parkour_app/bloc/bloc.dart';
import 'package:parkour_app/bloc/contribution/bloc.dart';
import 'package:parkour_app/provider/user_provider.dart';
import 'package:rxdart/rxdart.dart';

class ContributionBloc extends BLoC<ContributionEvent> {
  PublishSubject contributionSubject = PublishSubject<AuthState>();
  final UserProvider _userProvider = GetIt.instance<UserProvider>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _usersDbRef = FirebaseDatabase.instance.reference();

  @override
  void dispatch(ContributionEvent event) {
    // TODO: implement dispatch
  }

  void dispose() {
    contributionSubject.close();
  }
}
