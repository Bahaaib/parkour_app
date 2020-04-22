abstract class ProfileEvent {}

class UserDataUpdateRequested extends ProfileEvent {
  final Map<String, String> userData;

  UserDataUpdateRequested(this.userData);
}
