import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_state.dart';
import 'hymnClass.dart';

class HymnPage extends StatefulWidget {
  final Hymn hymn;

  const HymnPage({super.key, required this.hymn});

  @override
  State<HymnPage> createState() => _HymnPageState();
}

class _HymnPageState extends State<HymnPage> {
  late BannerAd bannerAd;

  bool isAdloaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBannerAd();

    loadString();
    checkFavoriteStatus();
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

  String hymnText = "";
  double fontSize = 22.0;

  final double minFontSize = 10.0;
  final double maxFontSize = 30.0;
  bool isFavorite = false; // Track favorite state

  Future<void> loadString() async {
    try {
      final String data = await rootBundle.loadString(widget.hymn.assetPath);
      setState(() {
        hymnText = data;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error loading hymn text: $e");
      }
    }
  }

  void shareText(
      String title, String appText, String playStoreLink, String prayerText) {
    Share.share(
      '$title\n\n$prayerText\n\n$appText\n\nDownload for free on Google Play Store:\n$playStoreLink',
      subject: 'Subject for sharing',
    );
  }

  void checkFavoriteStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoriteIds = prefs.getStringList('favoriteHymns') ?? [];
    setState(() {
      isFavorite = favoriteIds.contains(widget.hymn.id.toString());
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

  void toggleFavorite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoriteIds = prefs.getStringList('favoriteHymns') ?? [];

    if (isFavorite) {
      favoriteIds.remove(widget.hymn.id.toString());
    } else {
      favoriteIds.add(widget.hymn.id.toString());
    }

    await prefs.setStringList('favoriteHymns', favoriteIds);

    setState(() {
      isFavorite = !isFavorite;
    });

    final snackBar = SnackBar(
      content: Text(
        isFavorite ? 'Added to favorites' : 'Removed from favorites',
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black // Light mode text color
              : Colors.white, // Dark mode text color
        ),
      ),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          toggleFavorite(); // Revert the change
        },
        textColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black // Light mode text color for Undo
            : Colors.white, // Dark mode text color for Undo
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.greenAccent // Light mode background color
          : Colors.grey[700]!, // Dark mode background color
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final firstSentence = widget.hymn.name;
    return Scaffold(
      appBar: AppBar(
        title: Text(firstSentence),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.greenAccent // Light mode color
            : Colors.grey[800]!, // Dark mode color
        actions: <Widget>[
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              shareText(
                widget.hymn.name,
                appText,
                playStoreLink,
                hymnText,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: rootBundle.loadString(widget.hymn.assetPath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Handle error here
              return Column(
                children: [
                  if (isAdloaded)
                    SizedBox(
                      height: bannerAd.size.height.toDouble(),
                      width: bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: bannerAd),
                    ),
                  const SizedBox(),
                  Text('Error loading hymn: ${snapshot.error}'),
                ],
              );
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  if (isAdloaded)
                    SizedBox(
                      height: bannerAd.size.height.toDouble(),
                      width: bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: bannerAd),
                    ),
                  const SizedBox(),
                  Text(
                    snapshot.data ??
                        'No data available', // Provide a default value
                    style: TextStyle(fontSize: fontSize),
                  ),
                ],
              );
            } else {
              return const Text('Unknown error occurred');
            }
          },
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
    );
  }
}
