import 'package:flutter/material.dart';

import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  // dynamic _nikeStock = jsonDecode(
  //     '{\"items\":[{\"name\":\"Nike Air Max 270\",\"colors\":[\"#FC4303\",\"#3F19D6\"],\"price\":\"170\",\"category\":\"Tennis\",\"newCollection\":true,\"image\":\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/nike-store-f-f-new-year-challenge-9lc7ji/assets/as35ct9hhkkk/image-nike-air-max-270-400x400.png\"},{\"name\":\"Nike Waffle One SE\",\"colors\":[\"#529DEB\",\"#EF7514\"],\"price\":\"130\",\"category\":\"Lifestyle\",\"image\":\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/nike-store-f-f-new-year-challenge-9lc7ji/assets/jfj5b20f5e9m/image-nike-waffle-ne-se-400x400.png\"},{\"name\":\"Nike Legend Essential\",\"colors\":[\"#000000\"],\"price\":\"130\",\"category\":\"Lifestyle\",\"image\":\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/nike-store-f-f-new-year-challenge-9lc7ji/assets/4vrwi3wdiq4b/image-nike-legend-essential-400x400.png\"},{\"name\":\"Nike Air Max 97\",\"colors\":[\"#D1CEC2\"],\"price\":\"167\",\"category\":\"Tennis\",\"newCollection\":true,\"image\":\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/nike-store-f-f-new-year-challenge-9lc7ji/assets/kjxauc7j35sg/image-nike-air-max-97-400x400.png\"},{\"name\":\"Nike Zoom Freak\",\"colors\":[\"#EA6B5D\"],\"price\":\"179\",\"category\":\"Running\",\"newCollection\":true,\"image\":\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/nike-store-f-f-new-year-challenge-9lc7ji/assets/1c5w17bknep4/image-nike-zoom-freak-400x400.png\"},{\"name\":\"Nike Air Force\",\"colors\":[\"#3F4E9A\"],\"price\":\"149\",\"category\":\"Running\",\"image\":\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/nike-store-f-f-new-year-challenge-9lc7ji/assets/0q47xd2c7z59/image-nike-air-force-400x400.png\"}]}');
  // dynamic get nikeStock => _nikeStock;
  // set nikeStock(dynamic _value) {
  //   _nikeStock = _value;
  // }

  // bool _isLifestyleTab = true;
  // bool get isLifestyleTab => _isLifestyleTab;
  // set isLifestyleTab(bool _value) {
  //   _isLifestyleTab = _value;
  // }

  bool _isRunningTab = false;
  bool get isRunningTab => _isRunningTab;
  set isRunningTab(bool _value) {
    _isRunningTab = _value;
  }

  bool _isTennisTab = false;
  bool get isTennisTab => _isTennisTab;
  set isTennisTab(bool _value) {
    _isTennisTab = _value;
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

var adUnit = "ca-app-pub-1097230754498747/3141979130"; //testing ad

List myPages = [
  [
    "Hymns",
    "assets/images/music-book.png",
    "/Hymns"
  ], // Keep the route name as "/Hymns"
  ["Lord's Prayer", "assets/images/praying.png", "/LordsPrayer"],
  ["Apostles Creed", "assets/images/dove.png", "/ApostlesCreed"],
  ["Favorites", "assets/images/favourite.png", "/Favorites"],
];
var devices = ["410B7F1564C40DB1C6C45A628F8907C8"];
const playStoreLink =
    'https://play.google.com/store/apps/details?id=com.mabans.nyimbo_cia_kuinira_ngai';
String appText =
    'Check out Nyimbo Cia Kuinira Ngai app!'; // Replace with your own description
