import 'package:favorite_places/provider/place_provider.dart';
import 'package:favorite_places/screen/login.dart';
import 'package:flutter/material.dart';
import "package:favorite_places/screen/favorite_places.dart";
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_messaging/firebase_messaging.dart";
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  //inizializzazione firebase
  // per inizializzare i servizi esterni
  WidgetsFlutterBinding.ensureInitialized();

  //inizializza fb
  await Firebase.initializeApp();

  //inizializzazione analytics
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  //permesso per le notifiche push
  final notificationSettings = await FirebaseMessaging.instance
      .requestPermission(provisional: true);

  // For apple platforms, make sure the APNS token is available before making any FCM plugin API calls
  /*final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  if (apnsToken != null) {
    // APNS token is available, make FCM plugin API requests...
  }*/

  final fcmToken = await FirebaseMessaging.instance.getToken(
    vapidKey:
        "BAr1YH5b_YsEcKzzYgEcPVLlkOUXRoRVqtXFR-LxwJGu1l7nueT2Eo3Q8s4yxpAQFtH9Z-Matmbnj42HI8UefnI",
  );
  print("token: ${fcmToken}");

  // registrazione per la ricezione di notifiche
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {}).onError((
    err,
  ) {
    print(err);
  });

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        return PlaceProvider();
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Login());
  }
}
