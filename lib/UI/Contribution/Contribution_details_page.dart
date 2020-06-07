import 'package:flutter/material.dart';
import 'package:parkour_app/PODO/Contribution.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';

class ContributionDetailsPage extends StatefulWidget {
  @override
  _ContributionDetailsPageState createState() =>
      _ContributionDetailsPageState();
}

class _ContributionDetailsPageState extends State<ContributionDetailsPage> {
  Contribution _contribution;

  @override
  Widget build(BuildContext context) {
    _checkPassedArguments();

    return Scaffold(
      appBar: AppBar(
        title: _contribution.title != null
            ? Text(_contribution.title)
            : Container(),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTextLabel(AppStrings.aboutText, topMargin: 30.0),
            _buildDummyText(_contribution.description),
            _buildTextLabel(AppStrings.addressLabel, topMargin: 30.0),
            _buildDummyText(_contribution.address),
            _contribution.images != null
                ? _buildTextLabel(AppStrings.galleryLabel, topMargin: 30.0)
                : Container(),
            _buildImagesGallery()
          ],
        ),
      ),
    );
  }

  Widget _buildImagesGallery() {
    return _contribution.images != null
        ? Container(
            height: 400.0,
            margin: EdgeInsetsDirectional.only(
                start: 20, end: 20, top: 20.0, bottom: 20.0),
            child: GridView.builder(
                itemCount: _contribution.images.length,
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
                    child: Image.network(
                      _contribution.images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                }),
          )
        : Container();
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
    Map<String, Contribution> result;
    final args = ModalRoute.of(context).settings.arguments
        as Map<String, Map<String, Contribution>>;
    if (args != null) {
      setState(() {
        result = args['result'];
        _contribution = result['contribution'];
      });
    }
  }
}
