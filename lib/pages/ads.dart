import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/widgets.dart';

class Ads extends StatelessWidget {

  final String _adId = 'ca-app-pub-2856464717670030/9835623969';

  @override
  Widget build(BuildContext context) {
    return AdmobBanner(
      adUnitId: _adId,
      adSize: AdmobBannerSize.BANNER,
    );
  }
}
