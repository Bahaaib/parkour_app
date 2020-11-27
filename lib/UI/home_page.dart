import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/PODO/Contribution.dart';
import 'package:parkour_app/Widgets/drawer.dart';
import 'package:parkour_app/bloc/contribution/contribution_bloc.dart';
import 'package:parkour_app/bloc/contribution/contribution_event.dart';
import 'package:parkour_app/bloc/contribution/contribution_state.dart';
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
  final ContributionBloc _contributionsBloc =
      GetIt.instance<ContributionBloc>();
  final List<Contribution> _contributions = List<Contribution>();
  Map<MarkerId, Marker> markers = Map<MarkerId, Marker>();
  StreamSubscription _streamSubscription;

  String _result;

  //Default initial Position [Center of Germany]
  CameraPosition _currentPosition =
      CameraPosition(target: LatLng(51.3016091, 9.9586623), zoom: 15);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_result == CodeStrings.resultPasswordChangeSuccess) {
        _showSnackBar(
            AppStrings.passwordChangedMessage, CodeStrings.typeSuccess);
      }
    });

    _streamSubscription =
        _contributionsBloc.contributionSubject.listen((receivedState) {
      if (receivedState is ContributionsAreFetched) {
        setState(() {
          _contributions.clear();
          _contributions.addAll(receivedState.contributions);
          print('CONTRIBUTIONS COUNT = ${_contributions.length}');
        });
      }

      for (Contribution contribution in _contributions) {
        _addMarkersOnMap(LatLng(contribution.latitude, contribution.longitude),
            contribution.title);
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    _locationProvider.checkForLocationPermission();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _checkPassedArguments();

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
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
                LocationData _locationData =
                    await _locationProvider.getCurrentLocation();

                _currentPosition = CameraPosition(
                    target:
                        LatLng(_locationData.latitude, _locationData.longitude),
                    zoom: 15);
                _goToCurrentPosition();
              },
              markers: Set<Marker>.of(markers.values),
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
    _contributionsBloc.dispatch(ContributionsRequestedForMap());
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

  Future<void> _addMarkersOnMap(LatLng latlng, String title) async {
    setState(() {
      final MarkerId markerId = MarkerId(DateTime.now().toIso8601String());
      Marker marker = Marker(
          markerId: markerId,
          draggable: false,
          position: latlng,
          //With this parameter you automatically obtain latitude and longitude
          infoWindow: InfoWindow(
            title: title,
          ),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            print('MARKER PRESSED');
            //TODO: Open Details page for that marker position
            _contributionsBloc.dispatch(
                ContributionSelected(latlng.latitude, latlng.longitude));
          });

      markers[markerId] = marker;
    });
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

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
