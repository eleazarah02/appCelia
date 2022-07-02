// SHA1: 8B:9E:18:EE:A7:6D:4F:07:21:78:9A:5F:31:49:53:F1:9F:81:CC:40

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    //print('onBackground Handler ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'Sin titulo');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //print('onMessage Handler ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'Sin titulo');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //print('onMessageOpenApp Handler ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'Sin titulo');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();

    token = await FirebaseMessaging.instance.getToken();
    print(token);

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static closeStreams() {
    _messageStream.close();
  }
}
