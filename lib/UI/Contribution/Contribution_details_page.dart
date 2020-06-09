import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/PODO/Contribution.dart';
import 'package:parkour_app/PODO/Contributor.dart';
import 'package:parkour_app/provider/user_provider.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/support/router.gr.dart';

class ContributionDetailsPage extends StatefulWidget {
  @override
  _ContributionDetailsPageState createState() =>
      _ContributionDetailsPageState();
}

class _ContributionDetailsPageState extends State<ContributionDetailsPage> {
  final UserProvider _userProvider = GetIt.instance<UserProvider>();
  Contribution _contribution;
  String _from = 'list';
  Contributor _contributor;
  bool _isMyContribution = false;

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
            _buildImagesGallery(),
            _contributor != null ? _buildContributorSections() : Container()
          ],
        ),
      ),
    );
  }

  Widget _buildImagesGallery() {
    return _contribution.images != null
        ? Container(
            height: (_contribution.images.length / 2).round() * 120.0,
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

  Widget _buildContributorSections() {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          children: <Widget>[
            _buildTextLabel('Contributed by: ${_getContributorName()}',
                textColor: AppColors.primaryColor),
          ],
        ),
      ),
      onTap: () {
        if (_isMyContribution) {
          MainRouter.navigator.pushNamed(MainRouter.profilePage);
        } else {
          MainRouter.navigator.pushNamed(MainRouter.contributorDetailsPage,
              arguments: {'contributor': _contributor});
        }
      },
    );
  }

  String _getContributorName() {
    if (_contributor.child_id == _userProvider.user.child_id) {
      _isMyContribution = true;
      return 'You';
    } else {
      _isMyContribution = false;
      return _contributor.username;
    }
  }

  void _checkPassedArguments() {
    Map<String, dynamic> result;
    final args = ModalRoute.of(context).settings.arguments
        as Map<String, Map<String, dynamic>>;
    if (args != null) {
      setState(() {
        result = args['result'];
        _contribution = result['contribution'];
        _from = result['from'];
        _contributor = result['contributor'];
      });
    }
  }
}
