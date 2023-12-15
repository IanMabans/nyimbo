import 'package:flutter/material.dart';

import '/components/side_nav02_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for SideNav02 component.
  late SideNav02Model sideNav02Model;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    sideNav02Model = createModel(context, () => SideNav02Model());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    sideNav02Model.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
