import 'package:parkour_app/PODO/AuthUser.dart';
import 'package:parkour_app/provider/shared_prefrence_provider.dart';
import 'package:parkour_app/resources/strings.dart';

class UserProvider {
  Future<AuthUser> get user async {
    return _parseCachedData(await SharedPreferencesProvider.instance()
        .getUser(CodeStrings.userSharedPrefKEY));
  }

  Future<AuthUser> _parseCachedData(List<dynamic> dataList) async {
    if (dataList == null) {
      return null;
    }

    AuthUser user = AuthUser.cached(
      id: dataList[0],
      username: dataList[1],
      email_address: dataList[2],
      language: dataList[3],
      token: dataList[4],
    );
    return user;
  }
}
