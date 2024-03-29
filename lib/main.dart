import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart' show usePathUrlStrategy;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: devices,
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  usePathUrlStrategy();
  await initFirebase();

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>()!;
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    

    Future.delayed(
      const Duration(milliseconds: 1500), // Adjust the duration as needed
      () {
        setState(() => _appStateNotifier.stopShowingSplashImage());
      },
    );
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
      FlutterFlowTheme.saveThemeMode(mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NyimbociaNgai',
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: const ScrollbarThemeData(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scrollbarTheme: const ScrollbarThemeData(),
      ),
      themeMode: _themeMode,
      routerConfig: _router,
      builder: (context, router) {
        return _appStateNotifier.showSplashImage
            ? Container(
                color: const Color(0xFF39EF55),
                child: Image.asset(
                  'assets/images/playstore.png',
                  fit: BoxFit.fitWidth,
                ),
              )
            : router!;
      },
    );
  }
}
