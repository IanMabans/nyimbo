import '/components/side_nav02_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for SideNav02 component.
  late SideNav02Model sideNav02Model;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    sideNav02Model = createModel(context, () => SideNav02Model());
  }

  void dispose() {
    unfocusNode.dispose();
    sideNav02Model.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
