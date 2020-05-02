import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';

class ContributionsPage extends StatefulWidget {
  @override
  _ContributionsPageState createState() => _ContributionsPageState();
}

class _ContributionsPageState extends State<ContributionsPage> {
  List<String> _dummyDistances = ['1.5', '10.0', '22.7'];
  List<String> _dummyTitles = [
    'Mat & Richie Parcour Ground',
    'National Parcour Training Centre',
    'Matthias Open Ground for Parcour Training'
  ];
  List<String> _dummyDates = [
    'April 27, 2020',
    'May 01, 2020',
    'April 12, 2020'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.contributionsText),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int position) =>
                    _buildContributionListItem(_dummyDistances[position],
                        _dummyTitles[position], _dummyDates[position]),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContributionListItem(
      String distance, String title, String date) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: (){},
            contentPadding: EdgeInsets.all(0.0),
            leading: CircleAvatar(
              radius: 50.0,
              backgroundColor: AppColors.primaryLightColor,
              child: Text(
                distance + '\nKM',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.white, fontSize: 12.0),
              ),
            ),
            title: Container(
              padding: EdgeInsets.only(right: 40.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            subtitle: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  date,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0, color: AppColors.offGrey),
                ),
              ),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
