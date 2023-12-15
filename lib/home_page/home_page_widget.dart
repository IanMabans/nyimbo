import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyimbocia_ngai/home_page/pagesBox.dart';
import 'package:provider/provider.dart';

import '/components/side_nav02_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_model.dart';

export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  final double horizontalPadding = 40;

  final double verticalPadding = 25;

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour < 12) {
      return "Good morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Exit"),
          content: const Text("Are you sure you want to exit the app?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Exit"),
              onPressed: () {
                Navigator.of(context).pop();
                exit(0); // This will exit the app
              },
            ),
          ],
        );
      },
    );
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
        drawer: Drawer(
          elevation: 16.0,
          child: wrapWithModel(
            model: _model.sideNav02Model,
            updateCallback: () => setState(() {}),
            child: const SideNav02Widget(),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                        builder: (innerContext) => InkWell(
                              onTap: () {
                                Scaffold.of(innerContext).openDrawer();
                              },
                              child: Icon(
                                Icons.menu,
                                size: 35,
                                color: Colors.grey[800],
                              ),
                            )),
                    InkWell(
                      onTap: () {
                        _showExitConfirmationDialog(context);
                      },
                      child: Icon(
                        Icons.exit_to_app,
                        size: 35,
                        color: Colors.grey[800],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nyimbo Cia Kuinira Ngai',
                      style: GoogleFonts.bebasNeue(fontSize: 42),
                    ),
                    Text(
                      getGreeting(),
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade800),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 204, 204, 204),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(25),
                  itemCount: myPages.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.3,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        final routeName = myPages[index][2];
                        if (routeName != null) {
                          Navigator.of(context).pushNamed(routeName);
                        }
                      },
                      child: PagesBox(
                        pageName: myPages[index][0],
                        iconPath: myPages[index][1],
                        routeName: myPages[index][2],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
