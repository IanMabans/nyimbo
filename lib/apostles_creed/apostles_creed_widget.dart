import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'apostles_creed_model.dart';

export 'apostles_creed_model.dart';

class ApostlesCreedWidget extends StatefulWidget {
  const ApostlesCreedWidget({
    Key? key,
    this.item,
  }) : super(key: key);

  final dynamic item;

  @override
  _ApostlesCreedWidgetState createState() => _ApostlesCreedWidgetState();
}

class _ApostlesCreedWidgetState extends State<ApostlesCreedWidget> {
  late ApostlesCreedModel _model;
  late BannerAd bannerAd;

  bool isAdloaded = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initBannerAd();
    _model = createModel(context, () => ApostlesCreedModel());
    loadPrayerText();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  initBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isAdloaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (kDebugMode) {
              print(error);
            }
          },
        ),
        request: const AdRequest());

    bannerAd.load();
  }

  String creedText = "";
  double fontSize = 22.0;

  final double minFontSize = 10.0;
  final double maxFontSize = 30.0;

  void shareText(
      String title, String appText, String playStoreLink, String prayerText) {
    Share.share(
      '$title\n\n$prayerText\n\n$appText\n\nDownload for free on Google Play Store:\n$playStoreLink',
      subject: 'Subject for sharing',
    );
  }

  Future<void> loadPrayerText() async {
    const creedAssetPath =
        'assets/kikuyu apostles creed/Wĩtĩkio Ũrīa Wa Atũmwo.txt';
    final creedString = await rootBundle.loadString(creedAssetPath);

    setState(() {
      creedText = creedString;
    });
  }

  void zoomIn() {
    setState(() {
      if (fontSize < maxFontSize) {
        fontSize += 2.0;
      }
    });
  }

  void zoomOut() {
    setState(() {
      if (fontSize > minFontSize) {
        fontSize -= 2.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          title: const Text("Wĩtĩkio Ũrīa Wa Atũmwo"),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                shareText(
                  "IHOYA RIA MWATHANI",
                  appText,
                  playStoreLink,
                  creedText,
                );
              },
            ),
          ],
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.greenAccent // Light mode color
              : Colors.grey[800]!, // Dark mode color
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isAdloaded)
                SizedBox(
                  height: bannerAd.size.height.toDouble(),
                  width: bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: bannerAd),
                ),
              const SizedBox(),
              Card(
                borderOnForeground: true,
                shadowColor: Colors.transparent,
                elevation: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    creedText,
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'zmin',
              onPressed: zoomIn,
              tooltip: 'Zoom In',
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'zmout',
              onPressed: zoomOut,
              tooltip: 'Zoom Out',
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}
