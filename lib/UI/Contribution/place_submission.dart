import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parkour_app/bloc/contribution/bloc.dart';
import 'package:parkour_app/resources/colors.dart';
import 'package:parkour_app/resources/strings.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkour_app/support/router.gr.dart';

class PlaceSubmissionPage extends StatefulWidget {
  @override
  _PlaceSubmissionPageState createState() => _PlaceSubmissionPageState();
}

class _PlaceSubmissionPageState extends State<PlaceSubmissionPage> {
  final ContributionBloc _contributionBloc = GetIt.instance<ContributionBloc>();
  final GlobalKey<FormState> _infoFormKey = GlobalKey();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  List<File> _imageList = List<File>();
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    _streamSubscription =
        _contributionBloc.contributionSubject.listen((receivedState) {
      if (receivedState is ContributionIsSubmitted) {
        MainRouter.navigator
            .pushNamedAndRemoveUntil(MainRouter.confirmationPage, (_) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  ///TODO: Submit
                  _contributionBloc.dispatch(ContributionSubmissionRequested(
                      title: 'title',
                      description: 'desc',
                      address: 'address',
                      imageList: _imageList));
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
              _buildSubmitButton()
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
        onChanged: (value) {},
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
            ///TODO: Submit
            _contributionBloc.dispatch(ContributionSubmissionRequested(
                title: 'title',
                description: 'desc',
                address: 'address',
                imageList: _imageList));
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
