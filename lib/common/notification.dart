//
// class NotificationService {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   initInfo() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     var request = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     if (request.authorizationStatus == AuthorizationStatus.authorized ||
//         request.authorizationStatus == AuthorizationStatus.provisional) {
//       const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//       var iosInitializationSettings = const DarwinInitializationSettings(
//         requestSoundPermission: true,
//         defaultPresentAlert: true,
//         defaultPresentSound: true,
//       );
//       final InitializationSettings initializationSettings =
//       InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: iosInitializationSettings);
//       await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//           onDidReceiveNotificationResponse: (payload) {
//
//           });
//       setupInteractedMessage();
//     }
//   }
//
//   Future<void> setupInteractedMessage() async {
//     RemoteMessage? initialMessage =
//     await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       FirebaseMessaging.onBackgroundMessage(
//               (message) => firebaseMessageBackgroundHandle(message));
//     }
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       log("::::::::::::onMessage:::::::::::::::::");
//       if (message.notification != null) {
//         log(message.notification.toString());
//         display(message);
//       }
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       log("::::::::::::onMessageOpenedApp:::::::::::::::::");
//       if (message.notification != null) {
//         log(message.notification.toString());
//         if (message.data['type'] == "chat") {
//           await FireStoreUtils.getUserProfile(
//               message.data['senderId'] == FireStoreUtils.getCurrentUid()
//                   ? message.data['receiverId']
//                   : message.data['senderId'])
//               .then((value) {
//             UserModel userModel = value!;
//             Get.to(const ChatScreen(), arguments: {"receiverModel": userModel});
//           });
//         } else if (message.data['type'] == "order") {
//           OrderModel? orderModel =
//           await FireStoreUtils.getSingleOrder(message.data['orderId']);
//           Get.to(() => const MySummaryScreen(),
//               arguments: {"orderModel": orderModel});
//         }
//       }
//     });
//     log("::::::::::::Permission authorized:::::::::::::::::");
//     await FirebaseMessaging.instance.subscribeToTopic("QuicklAI");
//   }
//
//   static getToken() async {
//     String? token = await FirebaseMessaging.instance.getToken();
//     return token!;
//   }
//
//   void display(RemoteMessage message) async {
//     log('Got a message whilst in the foreground!');
//     log('Message data: ${message.notification!.body.toString()}');
//     try {
//       AndroidNotificationChannel channel = const AndroidNotificationChannel(
//         '0',
//         'ParkPal-customer',
//         description: 'Show QuickLAI Notification',
//         importance: Importance.max,
//       );
//       AndroidNotificationDetails notificationDetails =
//       AndroidNotificationDetails(channel.id, channel.name,
//           channelDescription: 'your channel Description',
//           importance: Importance.max,
//           priority: Priority.max,
//           ticker: 'ticker');
//       const DarwinNotificationDetails darwinNotificationDetails =
//       DarwinNotificationDetails(
//           sound: 'default',
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true);
//       NotificationDetails notificationDetailsBoth = NotificationDetails(
//           android: notificationDetails, iOS: darwinNotificationDetails);
//       await FlutterLocalNotificationsPlugin().show(
//         0,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetailsBoth,
//         payload: jsonEncode(message.data),
//       );
//     } on Exception catch (e) {
//       log(e.toString());
//     }
//   }
// }