import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../hymns/datahelperclass.dart';
import '../hymns/hymnClass.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'favorites_model.dart';

export 'favorites_model.dart';

class FavoritesWidget extends StatefulWidget {
  const FavoritesWidget({
    Key? key,
    this.item,
  }) : super(key: key);

  final dynamic item;

  @override
  _FavoritesWidgetState createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  late FavoritesModel _model;
  late BannerAd bannerAd;

  bool isAdloaded = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FavoritesModel());
    loadFavoriteHymns();
    initBannerAd();
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

  final HymnDatabaseHelper hymnDatabaseHelper = HymnDatabaseHelper();
  List<Hymn> favoriteHymns = [];

  Future<void> loadFavoriteHymns() async {
    final favoriteHymnsList = await hymnDatabaseHelper.getAllHymns(true);
    setState(() {
      favoriteHymns = favoriteHymnsList;
    });
  }

  Future<void> removeFavoriteHymn(Hymn hymn) async {
    // Toggle the favorite status of the hymn
    hymn.toggleFavorite();

    // You need to implement a method to update the database with the new favorite status.
    // This method should update the 'isFavorite' field in the database.

    // Reload the list of favorite hymns
    loadFavoriteHymns();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
            title: const Text("Favorite Hymns ❤️"),
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.greenAccent // Light mode color
                : Colors.grey[800]!, // Dark mode color
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (isAdloaded)
                SizedBox(
                  height: bannerAd.size.height.toDouble(),
                  width: bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: bannerAd),
                ),
              const SizedBox(), // Empty SizedBox to take no space
              if (favoriteHymns.isEmpty)
                const Center(
                  child: Text(
                    'You have no favorite hymns yet. Go to Hymns and add them',
                  ),
                ),
              if (favoriteHymns.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: favoriteHymns.length,
                    itemBuilder: (context, index) {
                      final hymn = favoriteHymns[index];

                      return Dismissible(
                        key: Key(hymn.id.toString()),
                        onDismissed: (direction) {
                          // Remove the hymn from favorites here
                          removeFavoriteHymn(hymn);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            hymn.name,
                            style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black87
                                  : Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Hymn ${hymn.number.toString()}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.deepOrange
                                  : Colors.orangeAccent,
                            ),
                          ),
                          onTap: () => GoRouter.of(context)
                              .go('/hymnPage', extra: {'hymn': hymn}),
                        ),
                      );
                    },
                  ),
                ),
            ],
          )),
    );
  }
}
