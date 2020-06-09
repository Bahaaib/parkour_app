import 'package:flutter/material.dart';
import 'package:parkour_app/PODO/Contributor.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';

class ContributorDetailsPage extends StatefulWidget {
  @override
  _ContributorDetailsPageState createState() => _ContributorDetailsPageState();
}

class _ContributorDetailsPageState extends State<ContributorDetailsPage> {
  Contributor _contributor;

  @override
  Widget build(BuildContext context) {
    _checkPassedArguments();

    return Scaffold(
      appBar: AppBar(
        title: Text('Contributor info'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextLabel(AppStrings.usernameLabel, topMargin: 30.0),
          _buildRegularField(
            text: _contributor.username,
            tag: CodeStrings.usernameTag,
          ),
          _buildTextLabel(AppStrings.addressLabel),
          _buildRegularField(
            text: _contributor.address,
            tag: CodeStrings.addressTag,
          ),
        ],
      ),
    );
  }

  Widget _buildRegularField({@required String tag, @required text}) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 20, end: 20, top: 10),
      child: TextFormField(
        enabled: false,
        initialValue: text,
      ),
    );
  }

  Widget _buildSocialAccountsForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSocialAccountField(
              text: _contributor.whatsapp_number,
              tag: CodeStrings.whatsappTag,
              prefixPath: CodeStrings.whatsappSmallIcon),
          _buildSocialAccountField(
              text: _contributor.facebook_url,
              tag: CodeStrings.facebookTag,
              prefixPath: CodeStrings.facebookSmallIcon),
          _buildSocialAccountField(
              text: _contributor.twitter_url,
              tag: CodeStrings.twitterTag,
              prefixPath: CodeStrings.twitterSmallIcon),
        ],
      ),
    );
  }

  Widget _buildSocialAccountField({
    @required String prefixPath,
    @required String tag,
    @required String text,
  }) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 20, end: 20, top: 40),
      child: TextFormField(
        enabled: false,
        initialValue: text,
        decoration: InputDecoration(
          prefixIcon: Image.asset(prefixPath),
        ),
      ),
    );
  }

  Widget _buildEmailRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildTextLabel(AppStrings.mailLabel, topMargin: 40.0),
          _buildTextLabel(_contributor.email_address,
              topMargin: 40.0, textColor: AppColors.offGrey, fontSize: 14.0)
        ],
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

  void _checkPassedArguments() {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, Contributor>;
    if (args != null) {
      setState(() {
        _contributor = args['contributor'];
      });
    }
  }
}
