import 'package:flutter/material.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';

class ContributionDetailsPage extends StatefulWidget {
  @override
  _ContributionDetailsPageState createState() =>
      _ContributionDetailsPageState();
}

class _ContributionDetailsPageState extends State<ContributionDetailsPage> {
  String _title;

  @override
  Widget build(BuildContext context) {
    _checkPassedArguments();

    return Scaffold(
      appBar: AppBar(
        title: _title != null ? Text(_title) : Container(),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTextLabel(AppStrings.aboutText, topMargin: 30.0),
            _buildDummyText(AppStrings.dummyDescriptionText),
            _buildTextLabel(AppStrings.addressLabel, topMargin: 30.0),
            _buildDummyText(AppStrings.dummyAddressText),
            _buildTextLabel(AppStrings.galleryLabel, topMargin: 30.0),
            _buildImagesGallery()
          ],
        ),
      ),
    );
  }

  Widget _buildImagesGallery() {
    return Container(
      height: 400.0,
      margin: EdgeInsetsDirectional.only(
          start: 20, end: 20, top: 20.0, bottom: 20.0),
      child: GridView.builder(
          itemCount: 5,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.offGrey),
              ),
              child: Image.asset(
                'assets/images/img_${index + 1}.jpg',
                fit: BoxFit.cover,
              ),
            );
          }),
    );
  }

  Widget _buildDummyText(String dummyText) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: 20.0),
      child: Text(
        dummyText,
        style: TextStyle(color: AppColors.offGrey),
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
    Map<String, String> result;
    final args = ModalRoute.of(context).settings.arguments
        as Map<String, Map<String, String>>;
    if (args != null) {
      setState(() {
        result = args['result'];
        _title = result['title'];
      });
    }
  }
}
