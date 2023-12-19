import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'datahelperclass.dart';
import 'hymnClass.dart';
import 'hymns_model.dart';

class HymnsWidget extends StatefulWidget {
  const HymnsWidget({Key? key}) : super(key: key);

  @override
  _HymnsWidgetState createState() => _HymnsWidgetState();
}

class _HymnsWidgetState extends State<HymnsWidget> {
  late HymnsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final HymnDatabaseHelper hymnDatabaseHelper = HymnDatabaseHelper();
  final ScrollController controller = ScrollController();
  List<Hymn> hymns = [];
  List<Hymn> filteredHymns = [];
  String searchQuery = '';
  bool isLoading = true; // Add a loading state
  bool databaseInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize the database
    hymnDatabaseHelper.initDatabase().then((_) async {
      final hymnList = await hymnDatabaseHelper.getAllHymns(false);

      if (hymnList.isEmpty) {
        // Hymn data doesn't exist in the database, so load and insert it
        await loadAndInsertHymnData();
      } else {
        // Hymn data already exists in the database, so just retrieve it
        setState(() {
          hymns = hymnList;
          filteredHymns = hymns;
          isLoading = false;
          if (kDebugMode) {
            print("Hymns loaded: ${hymnList.length}");
          }
        });
      }
    });

    // Reset the search query when returning to this page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        searchQuery = '';
      });
    });
    _model = createModel(context, () => HymnsModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  // Load and insert hymn data into the database
  Future<void> loadAndInsertHymnData() async {
    final hymnList = await hymnDatabaseHelper.loadHymnDataFromAssets();
    setState(() {
      hymns = hymnList;
      filteredHymns = hymns;
      isLoading = false;
      print("Hymns loaded: ${hymnList.length}");
    });
  }

  void toggleFavorite(Hymn hymn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoriteIds = prefs.getStringList('favoriteHymns') ?? [];

    setState(() {
      hymn.isFavorite = !hymn.isFavorite;
    });

    if (hymn.isFavorite) {
      favoriteIds.add(hymn.id.toString());
    } else {
      favoriteIds.remove(hymn.id.toString());
    }

    prefs.setStringList('favoriteHymns', favoriteIds);

    final snackBar = SnackBar(
      content: Text(
        hymn.isFavorite ? 'Added to favorites' : 'Removed from favorites',
      ),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            hymn.isFavorite = !hymn.isFavorite;
          });
          if (hymn.isFavorite) {
            favoriteIds.add(hymn.id.toString());
          } else {
            favoriteIds.remove(hymn.id.toString());
          }
          prefs.setStringList('favoriteHymns', favoriteIds);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void searchHymns(String query) {
    setState(() {
      searchQuery = query;
      filteredHymns = hymns.where((hymn) {
        final name = hymn.name.toLowerCase();
        final number = hymn.number.toString();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || number.contains(searchLower);
      }).toList();
    });
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
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 10.0, 20.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(13.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).borderIcons,
                            width: 2.0,
                          ),
                        ),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.safePop();
                          },
                          child: Icon(
                            Icons.chevron_left,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 20.0,
                          ),
                        ),
                      ),
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(13.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).borderIcons,
                            width: 2.0,
                          ),
                        ),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.exit_to_app,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 22.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16.0, 10.0, 16.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x34090F13),
                                offset: Offset(0.0, 2.0),
                              )
                            ],
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
                            child: TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Search Hymns',
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelLarge,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                contentPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        24.0, 12.0, 12.0, 12.0),
                                prefixIcon: Icon(
                                  Icons.search_sharp,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                              onChanged: (query) => searchHymns(query),
                              style: FlutterFlowTheme.of(context).bodyLarge,
                              validator: _model.textControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          height: 716.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 6.0,
                                color: Color(0x1B090F13),
                                offset: Offset(0.0, -2.0),
                              )
                            ],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(0.0),
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                          ),
                          child: ListView.builder(
                            itemCount: filteredHymns.length,
                            itemBuilder: (BuildContext context, int index) {
                              Hymn hymn = filteredHymns[index];
                              return ListTile(
                                  title: Text(
                                    hymn.name,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors
                                              .black87 // Light mode text color
                                          : Colors
                                              .white, // Dark mode text color
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Hymn ${hymn.number.toString()}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors
                                              .deepOrange // Light mode text color
                                          : Colors
                                              .orangeAccent, // Dark mode text color
                                    ),
                                  ),
                                  onTap: () => GoRouter.of(context)
                                      .go('/hymnPage', extra: {'hymn': hymn}));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
