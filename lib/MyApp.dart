import 'package:parkour_app/bloc/auth/auth_bloc.dart';
import 'package:parkour_app/bloc/contribution/bloc.dart';
import 'package:parkour_app/bloc/profile/profile_bloc.dart';
import 'package:parkour_app/provider/admob_provider.dart';
import 'package:parkour_app/provider/location_provider.dart';
import 'package:parkour_app/provider/shared_prefrence_provider.dart';
import 'package:parkour_app/provider/user_provider.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/resources/themes.dart';
import 'package:parkour_app/support/FileFactory.dart';
import 'package:parkour_app/support/NetworkProvider/APIManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:load/load.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parkour_app/support/router.gr.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GetIt getit = GetIt.instance;
  String BUILDNUMBER = "build";
  String locale = CodeStrings.englishCode;
  @override
  void initState() {
    _getInfo();
    _initData();
    _onLangUpdate();
    super.initState();
  }

  void _onLangUpdate(){
    AppStrings.langChangedSubject.listen((String locale){
      SharedPreferencesProvider.instance().setLocale(locale);
      setState(() {
        this.locale = locale;
      });
    });
  }

  void _initData() {
    GetIt.instance.reset();

    GetIt.instance.registerSingleton<FileFactory>(FileFactory());
    GetIt.instance.registerSingleton<UserProvider>(UserProvider());
    GetIt.instance.registerSingleton<AdmobProvider>(AdmobProvider());
    GetIt.instance.registerSingleton<LocationProvider>(LocationProvider());
    GetIt.instance.registerSingleton<APIManager>(APIManager());
    GetIt.instance.registerSingleton<AuthBloc>(AuthBloc());
    GetIt.instance.registerSingleton<ProfileBloc>(ProfileBloc());
    GetIt.instance.registerSingleton<ContributionBloc>(ContributionBloc());

  }

  Future<void> _getInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final SharedPreferencesProvider sharedPrefs =
    SharedPreferencesProvider.instance();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    print("App name is $appName");
    print("Package name is $packageName");
    print("Version is $version");
    print("Build number is $buildNumber");

    String cachedBuild = await SharedPreferencesProvider.instance().getBuildNumber(BUILDNUMBER);
    if (cachedBuild == null ||
        int.parse(buildNumber) > int.parse(cachedBuild)) {
      _clearCache();
      sharedPrefs.setBuildNumber(buildNumber);
    }
  }

  void _clearCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingProvider(
      child: Material(
        child: MaterialApp(
          locale: Locale(locale),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale(CodeStrings.germanCode),
            const Locale(CodeStrings.englishCode),
          ],
          debugShowCheckedModeBanner: false,
          onGenerateRoute: MainRouter.onGenerateRoute,
          //initialRoute: MainRouter.splashScreen,
          theme: AppThemes.appTheme,
          navigatorKey: MainRouter.navigatorKey,
        ),
      ),
    );
  }
}
