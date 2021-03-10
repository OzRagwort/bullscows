
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobManager {

  InterstitialAd myInterstitial;

  String _interstitialID = 'ca-app-pub-0737873676591453/2483518290';
  // String _interstitialID = InterstitialAd.testAdUnitId;

  init() async {
    myInterstitial = InterstitialAd(
      adUnitId: _interstitialID,
      request: AdRequest(),
      listener: AdListener(),
    );
    myInterstitial..load();
  }

  show() {
    myInterstitial..show();
  }

  dispose() {
    myInterstitial.dispose();
  }

}
