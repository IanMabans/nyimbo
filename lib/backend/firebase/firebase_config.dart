import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCi9WyfFaiWlXsnYdW8vlkhZghW0IwTvOI",
            authDomain: "nyimbo-2c45a.firebaseapp.com",
            projectId: "nyimbo-2c45a",
            storageBucket: "nyimbo-2c45a.appspot.com",
            messagingSenderId: "942153321404",
            appId: "1:942153321404:web:b4c55d5a085446a2e279b9",
            measurementId: "G-LKRJM0SX2T"));
  } else {
    await Firebase.initializeApp();
  }
}
