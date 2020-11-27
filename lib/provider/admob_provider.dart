import 'package:firebase_admob/firebase_admob.dart';
import 'package:device_id/device_id.dart';

class AdmobProvider {
  //Google Admob
  MobileAdTargetingInfo targetingInfo;
  BannerAd _bannerAd1;
  BannerAd _bannerAd2;

  Future<void> setAdTargetingInfo(List<String> keywords) async {
    String testDevice = await DeviceId.getID;

    targetingInfo = MobileAdTargetingInfo(
      testDevices: testDevice != null ? <String>[testDevice] : null,
      keywords: keywords,
      childDirected: true,
      nonPersonalizedAds: true,
    );
  }

  BannerAd _createBannerAd1({String bannerId}) {
    return BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  void loadAndShowBannerAd1(
      {double anchorOffset = 0.0,
      AnchorPosition anchorPosition = AnchorPosition.TOP,
      double horizontalCenterOffset = 0.0}) {
    _bannerAd1 = _createBannerAd1(bannerId: BannerAd.testAdUnitId);

    _bannerAd1
      ..load()
      ..show(
          anchorOffset: anchorOffset,
          anchorType: anchorPosition == AnchorPosition.BOTTOM
              ? AnchorType.top
              : AnchorType.bottom,
          horizontalCenterOffset: horizontalCenterOffset);
  }

  BannerAd _createBannerAd2({String bannerId}) {
    return BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  void loadAndShowBannerAd2(
      {double anchorOffset = 0.0,
        AnchorPosition anchorPosition = AnchorPosition.TOP,
        double horizontalCenterOffset = 0.0}) {
    _bannerAd2 = _createBannerAd2(bannerId: BannerAd.testAdUnitId);

    _bannerAd2
      ..load()
      ..show(
          anchorOffset: anchorOffset,
          anchorType: anchorPosition == AnchorPosition.TOP
              ? AnchorType.top
              : AnchorType.bottom,
          horizontalCenterOffset: horizontalCenterOffset);
  }

  void dispose() {
    _bannerAd1?.dispose();
    _bannerAd2?.dispose();
  }
}

enum AnchorPosition { TOP, BOTTOM }
