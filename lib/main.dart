// ignore_for_file: deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifications_app/second_screen.dart';

// Classe que descreve um canal de notificação do Android
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Id Mensagem :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'First Screen',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final String _secondScreen;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('$notification.title'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$notification.body'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  // Envio de Notificação toda vez que o botão for pressionado
  void _fetchData() {
    flutterLocalNotificationsPlugin.show(
      0,
      'Notificação Teste',
      'Saiba Mais!',
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          color: Colors.blue,
          importance: Importance.max,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              minWidth: 200,
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Colors.blue,
              child: const Text(
                'Enviar uma notificação',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                _fetchData();
                print('A new onMessage event was published!');
              },
            ),
          ],
        ),
      ),
    );
  }
}
