import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/Widgets/drawer.dart';
import 'package:parkour_app/provider/location_provider.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:parkour_app/support/router.gr.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  final LocationProvider _locationProvider = GetIt.instance<LocationProvider>();

  String _result;

  //Default initial Position [Center of Germany]
  CameraPosition _currentPosition = CameraPosition(
      target: LatLng(51.3016091,9.9586623), zoom: 15);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_result == CodeStrings.resultPasswordChangeSuccess) {
        _showSnackBar(
            AppStrings.passwordChangedMessage, CodeStrings.typeSuccess);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _checkPassedArguments();
    _locationProvider.checkForLocationPermission();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              MainRouter.navigator.pushNamed(MainRouter.placeSubmissionPage),
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
          backgroundColor: AppColors.primaryColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        key: _scaffoldKey,
        drawer: MainDrawer(),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _currentPosition,
              onMapCreated: (GoogleMapController controller) async{
                _controller.complete(controller);
                LocationData _locationData = await _locationProvider.getCurrentLocation();

                _currentPosition = CameraPosition(
                    target: LatLng(_locationData.latitude, _locationData.longitude),
                    zoom: 15);
                _goToCurrentPosition();
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 40.0, left: 20.0),
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
                icon: Icon(
                  Icons.menu,
                  color: AppColors.black,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> _goToCurrentPosition() async {
    print('PLAYING POSITION: ${_currentPosition.target.latitude}');
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentPosition));
  }

  void _checkPassedArguments() {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    if (args != null) {
      setState(() {
        _result = args['result'];
      });
    }
  }

  void _showSnackBar(String message, String type) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
                type == CodeStrings.typeError
                    ? Icons.warning
                    : Icons.check_circle,
                color: type == CodeStrings.typeError
                    ? AppColors.white
                    : Colors.lightGreen),
            SizedBox(
              width: 8.0,
            ),
            Text(
              message,
              style: TextStyle(
                  color: type == CodeStrings.typeError
                      ? AppColors.white
                      : Colors.lightGreen),
            ),
          ],
        ),
      ),
    );
  }
}
