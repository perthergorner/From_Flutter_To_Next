import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:kirihare/utils/utils.dart';

class FireBaseNotification {
  static void init() async {
    firebaseConfigNotification();
  }

  static void firebaseConfigNotification() async {
    // TODO:
    if (!kIsWeb) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      await FirebaseMessaging.instance.requestPermission(sound: true, badge: true, alert: true, provisional: false);
      await FirebaseMessaging.instance.subscribeToTopic("kirihare-app");
    } else {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
      );
      String? token = await messaging.getToken();
    }

    FirebaseMessaging.instance.getInitialMessage().then((message) {
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      if (message.notification != null) showNotificationToDesktop(message.notification?.body ?? ""); // add number phone sussce
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    });
    //topic
  }

// Declared as global, outside of any class
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }
}
