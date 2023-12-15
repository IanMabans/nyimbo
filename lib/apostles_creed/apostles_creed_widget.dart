import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ApostlesCreedModel());
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 30.0, 20.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
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
                              Icons.chevron_left_outlined,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 20.0,
                            ),
                          ),
                        ),
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
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
                              Icons.share_sharp,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 22.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.03, -0.72),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'Hello World',
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
