import 'package:elbekgram/chats/profileview.dart';
import 'package:elbekgram/pages/intro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:elbekgram/chats/homepage.dart';
import 'package:elbekgram/firebase_options.dart';
import 'package:elbekgram/var_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'Fow showing message notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  print(result);
  debugPrint(result);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) {
        return VarProvider();
      },
      child: MyApp()));
}

class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      debugPrint('DATAAAAAAAAAA$dynamicLinkData');
      print('DATAAAAAAAAAA$dynamicLinkData');
      String link = dynamicLinkData.link.toString();
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyProfile(uid: link.split('elbeekk/')[1]),),(route) => false,);
    }).onError((e){debugPrint(e.me);});
  }
 @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    return MaterialApp(
        title: "e.gram",
        theme: ThemeData(
            brightness: darkMode ? Brightness.dark : Brightness.light),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const HomePage();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.hasError}"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
            }
            return const IntroPage();
          },
        ));
  }
}
