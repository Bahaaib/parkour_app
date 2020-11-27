import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/PODO/Contribution.dart';
import 'package:parkour_app/bloc/contribution/bloc.dart';
import 'package:parkour_app/bloc/contribution/contribution_bloc.dart';
import 'package:parkour_app/provider/admob_provider.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/support/router.gr.dart';

class ContributionsPage extends StatefulWidget {
  @override
  _ContributionsPageState createState() => _ContributionsPageState();
}

class _ContributionsPageState extends State<ContributionsPage> {
  final ContributionBloc _contributionsBloc =
      GetIt.instance<ContributionBloc>();
  final List<Contribution> _contributions = List<Contribution>();
  StreamSubscription _streamSubscription;
  final AdmobProvider _admobProvider = GetIt.instance<AdmobProvider>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _admobProvider.setAdTargetingInfo(['sports', 'archery', 'hiking']);
    });

    _streamSubscription =
        _contributionsBloc.contributionSubject.listen((receivedState) {
      if (receivedState is ContributionsAreFetched) {
        setState(() {
          _contributions.clear();
          _contributions.addAll(receivedState.contributions);
        });
      }
    });
    _contributionsBloc.dispatch(ContributionsRequested());
    _admobProvider.loadAndShowBannerAd1();
    _admobProvider.loadAndShowBannerAd2(anchorOffset: 80.0);
    super.initState();
  }

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
            child: _contributions.isNotEmpty
                ? Container(
                    margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                    child: ListView.builder(
                      itemCount: _contributions.length,
                      itemBuilder: (BuildContext context, int position) =>
                          _buildContributionListItem(
                        _contributions[position],
                      ),
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  Widget _buildContributionListItem(Contribution contribution) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => MainRouter.navigator
              .pushNamed(MainRouter.contributionDetailsPage, arguments: {
            'result': {'contribution': contribution}
          }),
          child: Container(
            padding: EdgeInsets.only(right: 20.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(0.0),
              leading: CircleAvatar(
                radius: 50.0,
                backgroundColor: AppColors.primaryLightColor,
                child: Text(
                  contribution.distanceToCurrentLocation.toStringAsFixed(2) +
                      '\nKM',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.white, fontSize: 12.0),
                ),
              ),
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  contribution.title,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text(
                    contribution.submission_date,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0, color: AppColors.offGrey),
                  ),
                ),
              ),
            ),
          ),
        ),
        Divider()
      ],
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _admobProvider.dispose();
    super.dispose();
  }
}
