import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kirihare/common/common.dart';
import 'package:kirihare/common/constants.dart';
import 'package:kirihare/common/fireBase_notification.dart';
import 'package:kirihare/page/chat.dart';
import 'package:kirihare/page/login.dart';
import 'package:google_fonts/google_fonts.dart';

enum DeviceType { Phone, Tablet }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAIRO50KmNRLxF_nV9Uoro3ovXG7vzZFKI",
            authDomain: "kirihare-web.firebaseapp.com",
            projectId: "kirihare-web",
            storageBucket: "kirihare-web.appspot.com",
            messagingSenderId: "363672539637",
            appId: "1:363672539637:web:4c134516a1b50bbfdb90bc",
            measurementId: "G-DH9YHPZBPG"));
  } else {
    await Firebase.initializeApp();
  }
  //setUrlStrategy(PathUrlStrategy()); // urlの「#」を消している
  HttpOverrides.global = MyHttpOverrides();
  FireBaseNotification.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => {
    runApp(MyApp()
    )});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = false;

  @override
  void initState() {
    super.initState();

    if (getDeviceType() == DeviceType.Phone) {
      Common.device = Constants.SMART_PHONE;
    } else {
      Common.device = Constants.PC;
    }
  }

  DeviceType getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 550 ? DeviceType.Phone : DeviceType.Tablet;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ja', ''),
      ],
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/ChatPage': (BuildContext context) => ChatPage(),
        '/LoginPage': (BuildContext context) => LoginPage()
      },
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
