import 'package:elbekgram/pages/intro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:elbekgram/chats/homepage.dart';
import 'package:elbekgram/firebase_options.dart';
import 'package:elbekgram/var_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: 'elbekgram',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) {
        return VarProvider();
      },
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    return MaterialApp(
        title: "Elbekgram",
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
