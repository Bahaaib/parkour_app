import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/bloc/profile/bloc.dart';
import 'package:parkour_app/provider/admob_provider.dart';
import 'package:parkour_app/provider/user_provider.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileBloc _profileBloc = GetIt.instance<ProfileBloc>();
  final GlobalKey<FormState> _infoFormKey = GlobalKey();
  final GlobalKey<FormState> _socialAccountsFormKey = GlobalKey();
  final FocusNode _addressFocusNode = FocusNode();
  final UserProvider _userProvider = GetIt.instance<UserProvider>();
  final AdmobProvider _admobProvider = GetIt.instance<AdmobProvider>();


  final List<TextEditingController> _controllers =
      List<TextEditingController>.generate(
          5, (controller) => TextEditingController());

  Map<String, String> _userData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _admobProvider.setAdTargetingInfo(['sports', 'archery', 'hiking']);
    });
    _setInitialValues();
    _userData = {
      'username': _controllers[0].text,
      'address': _controllers[1].text,
      'whatsapp_number': _controllers[2].text,
      'facebook_url': _controllers[3].text,
      'twitter_url': _controllers[4].text,
    };
    _admobProvider.loadAndShowBannerAd1();
    super.initState();
  }

  void _setInitialValues() {
    _controllers[0].text = _userProvider.user.username;
    _controllers[1].text = _userProvider.user.address;
    _controllers[2].text = _userProvider.user.whatsapp_number;
    _controllers[3].text = _userProvider.user.facebook_url;
    _controllers[4].text = _userProvider.user.twitter_url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profileText),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.check,
                color: AppColors.white,
              ),
              onPressed: () =>
                  _profileBloc.dispatch(UserDataUpdateRequested(_userData)))
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextLabel(AppStrings.generalInfoText,
                  topMargin: 40.0, fontSize: 20.0),
              _buildInfoForm(),
              _buildEmailRow(),
              _buildTextLabel(AppStrings.socialAccountsText,
                  topMargin: 40.0, fontSize: 20.0),
              _buildSocialAccountsForm(),
              _buildSaveButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoForm() {
    return Form(
      key: _infoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextLabel(AppStrings.usernameLabel, topMargin: 30.0),
          _buildRegularField(
              tag: CodeStrings.usernameTag,
              controller: _controllers[0],
              hint: AppStrings.usernameHint,
              destinationNode: _addressFocusNode),
          _buildTextLabel(AppStrings.addressLabel),
          _buildRegularField(
              tag: CodeStrings.addressTag,
              controller: _controllers[1],
              hint: AppStrings.addressHint,
              fieldNode: _addressFocusNode),
        ],
      ),
    );
  }

  Widget _buildRegularField(
      {@required String hint,
      @required String tag,
      @required controller,
      FocusNode fieldNode,
      FocusNode destinationNode}) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 20, end: 20, top: 10),
      child: TextFormField(
        controller: controller,
        focusNode: fieldNode,
        keyboardType: TextInputType.text,
        maxLength: 64,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.darkGrey),
        ),
        onChanged: (value) {
          _userData[tag] = value;
        },
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(destinationNode),
      ),
    );
  }

  Widget _buildSocialAccountsForm() {
    return Form(
      key: _socialAccountsFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSocialAccountField(
              tag: CodeStrings.whatsappTag,
              hint: AppStrings.whatsappHint,
              controller: _controllers[2],
              prefixPath: CodeStrings.whatsappSmallIcon),
          _buildSocialAccountField(
              tag: CodeStrings.facebookTag,
              hint: AppStrings.facebookHint,
              controller: _controllers[3],
              prefixPath: CodeStrings.facebookSmallIcon),
          _buildSocialAccountField(
              tag: CodeStrings.twitterTag,
              hint: AppStrings.twitterHint,
              controller: _controllers[4],
              prefixPath: CodeStrings.twitterSmallIcon),
        ],
      ),
    );
  }

  Widget _buildSocialAccountField(
      {@required String hint,
      @required String prefixPath,
      @required String tag,
      @required controller,
      FocusNode fieldNode,
      FocusNode destinationNode}) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 20, end: 20, top: 40),
      child: TextFormField(
        controller: controller,
        focusNode: fieldNode,
        keyboardType: TextInputType.url,
        decoration: InputDecoration(
          prefixIcon: Image.asset(prefixPath),
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.darkGrey),
        ),
        onChanged: (value) {
          _userData[tag] = value;
        },
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(destinationNode),
      ),
    );
  }

  Widget _buildEmailRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildTextLabel(AppStrings.mailLabel, topMargin: 40.0),
          _buildTextLabel(_userProvider.user.email_address,
              topMargin: 40.0, textColor: AppColors.offGrey)
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70.0,
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      margin:
          EdgeInsetsDirectional.only(start: 20, end: 20, top: 30, bottom: 50),
      child: RaisedButton(
        color: AppColors.primaryColor,
        child: Text(
          AppStrings.saveButtonLabel,
          style: TextStyle(
              color: AppColors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () =>
            _profileBloc.dispatch(UserDataUpdateRequested(_userData)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildTextLabel(String label,
      {double topMargin = 20.0,
      double fontSize = 16.0,
      Color textColor = const Color(0xff000000)}) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: topMargin),
      child: Text(
        label,
        style: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  @override
  void dispose() {
    _admobProvider.dispose();
    super.dispose();
  }
}
