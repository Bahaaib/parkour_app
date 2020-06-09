import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/bloc/auth/auth_bloc.dart';
import 'package:parkour_app/bloc/auth/auth_event.dart';
import 'package:parkour_app/bloc/contribution/bloc.dart';
import 'package:parkour_app/provider/location_provider.dart';
import 'package:parkour_app/provider/user_provider.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkour_app/support/router.gr.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceSubmissionPage extends StatefulWidget {
  @override
  _PlaceSubmissionPageState createState() => _PlaceSubmissionPageState();
}

class _PlaceSubmissionPageState extends State<PlaceSubmissionPage> {
  final ContributionBloc _contributionBloc = GetIt.instance<ContributionBloc>();
  final GlobalKey<FormState> _infoFormKey = GlobalKey();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  List<File> _imageList = List<File>();
  StreamSubscription _streamSubscription;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  final UserProvider _userProvider = GetIt.instance<UserProvider>();
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();
  final LocationProvider _locationProvider = GetIt.instance<LocationProvider>();
  Map<MarkerId, Marker> markers = Map<MarkerId, Marker>();
  double _latitude;
  double _longitude;

  String _title;
  String _address;
  String _description;

  //Default initial Position [Center of Germany]
  CameraPosition _currentPosition =
      CameraPosition(target: LatLng(51.3016091, 9.9586623), zoom: 15);

  @override
  void initState() {
    _streamSubscription =
        _contributionBloc.contributionSubject.listen((receivedState) {
      if (receivedState is ContributionIsSubmitted) {
        MainRouter.navigator
            .pushNamedAndRemoveUntil(MainRouter.confirmationPage, (_) => false);
      }
    });
    _authBloc.dispatch(UserDataByCachedIdRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppStrings.addPlaceText),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.send,
                color: AppColors.white,
              ),
              onPressed: () {
                if (_infoFormKey.currentState.validate()) {
                  if (_isLocationPicked()) {
                    if (_userProvider.user.username != null &&
                        _userProvider.user.username.isNotEmpty) {
                      ///TODO: Submit
                      _contributionBloc.dispatch(RequestSubmissionRequested(
                          title: _title,
                          description: _description,
                          address: _address,
                          imageList: _imageList,
                          latitude: _latitude,
                          longitude: _longitude));
                    } else {
                      _showSnackBar(
                          'Please complete your profile before contribution',
                          CodeStrings.typeError);
                    }
                  } else {
                    _showSnackBar('Parcour location MUST be picked on map',
                        CodeStrings.typeError);
                  }
                }
              })
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildInfoForm(),
              _buildGallerySection(),
              _buildLocationPicker(),
              _buildSubmitButton(),
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
          _buildTextLabel(AppStrings.titleLabel, topMargin: 30.0),
          _buildRegularField(
              tag: CodeStrings.titleTag,
              hint: AppStrings.titleHint,
              destinationNode: _descriptionFocusNode),
          _buildTextLabel(AppStrings.descLabel, topMargin: 30.0),
          _buildRegularField(
              tag: CodeStrings.descriptionTag,
              hint: AppStrings.descHint,
              fieldNode: _descriptionFocusNode,
              destinationNode: _addressFocusNode),
          _buildTextLabel(AppStrings.addressLabel, topMargin: 30.0),
          _buildRegularField(
            tag: CodeStrings.addressTag,
            hint: AppStrings.placeAddressHint,
            fieldNode: _addressFocusNode,
          ),
        ],
      ),
    );
  }

  Widget _buildRegularField(
      {@required String hint,
      @required String tag,
      FocusNode fieldNode,
      FocusNode destinationNode}) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 20, end: 20, top: 10),
      child: TextFormField(
        focusNode: fieldNode,
        keyboardType: TextInputType.text,
        maxLength: tag == CodeStrings.descriptionTag ? 512 : 64,
        maxLines: tag == CodeStrings.descriptionTag ? 8 : 1,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.darkGrey),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return AppStrings.fieldRequiredError;
          }

          return null;
        },
        onChanged: (value) {
          switch (tag) {
            case CodeStrings.titleTag:
              _title = value;
              break;
            case CodeStrings.descriptionTag:
              _description = value;
              break;
            case CodeStrings.addressTag:
              _address = value;
              break;
          }
        },
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(destinationNode),
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

  Widget _buildTextHint(String label,
      {double topMargin = 20.0,
      double fontSize = 16.0,
      Color textColor = const Color(0xff000000)}) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 20, end: 20, top: topMargin),
      child: Text(
        label,
        style: TextStyle(fontSize: fontSize, color: textColor),
      ),
    );
  }

  Widget _buildGallerySection() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextLabel(AppStrings.imagesLabel),
          Row(
            children: <Widget>[
              Row(
                children: _imageList.map((image) {
                  return Container(
                    margin: const EdgeInsets.only(top: 20.0, left: 20.0),
                    width: 50.0,
                    height: 50.0,
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
              _imageList.length < 5
                  ? Container(
                      margin: const EdgeInsets.only(top: 20.0, left: 20.0),
                      child: DottedBorder(
                        color: AppColors.offGrey,
                        strokeWidth: 1,
                        child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: AppColors.offGrey,
                            ),
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _pickImageFromGallery();
                            }),
                      ),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLocationPicker() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextLabel(AppStrings.locationLabel),
          _buildTextHint(AppStrings.locationHint,
              fontSize: 14.0, textColor: AppColors.offGrey),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 400.0,
            margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: GoogleMap(
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
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
              onLongPress: (latlng) {
                _addMarkerLongPressed(latlng);
                _latitude = latlng.latitude;
                _longitude = latlng.longitude;
              },
              markers: Set<Marker>.of(markers.values),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageList.add(image);
      });
    }
  }

  Widget _buildSubmitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70.0,
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      margin:
          EdgeInsetsDirectional.only(start: 20, end: 20, top: 30, bottom: 10),
      child: RaisedButton(
        color: AppColors.primaryColor,
        child: Text(
          AppStrings.submitButtonLabel,
          style: TextStyle(
              color: AppColors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (_infoFormKey.currentState.validate()) {
            if (_isLocationPicked()) {
              if (_userProvider.user.username != null &&
                  _userProvider.user.username.isNotEmpty) {
                ///TODO: Submit
                _contributionBloc.dispatch(RequestSubmissionRequested(
                    title: _title,
                    description: _description,
                    address: _address,
                    imageList: _imageList,
                    latitude: _latitude,
                    longitude: _longitude));
              } else {
                _showSnackBar(
                    'Please complete your profile before contribution',
                    CodeStrings.typeError);
              }
            } else {
              _showSnackBar('Parcour location MUST be picked on map',
                  CodeStrings.typeError);
            }
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  bool _isLocationPicked() {
    return _latitude != null && _longitude != null;
  }

  Future<void> _goToCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentPosition));
  }

  Future<void> _addMarkerLongPressed(LatLng latlng) async {
    setState(() {
      final MarkerId markerId = MarkerId("RANDOM_ID");
      Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        position: latlng,
        //With this parameter you automatically obtain latitude and longitude
        infoWindow: InfoWindow(
          title: "Selected Parcour Location",
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      markers[markerId] = marker;
    });

    //This is optional, it will zoom when the marker has been created
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(latlng, 15.0));
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
                    ? AppColors.errorColor
                    : Colors.lightGreen),
            SizedBox(
              width: 8.0,
            ),
            Text(
              message,
              style: TextStyle(
                  color: type == CodeStrings.typeError
                      ? AppColors.errorColor
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
