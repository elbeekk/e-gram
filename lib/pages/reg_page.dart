import 'dart:async';

import 'package:csc_picker/csc_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:elbekgram/helpers/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:elbekgram/chats/homepage.dart';
import 'package:elbekgram/pages/create_acc.dart';
import 'package:elbekgram/var_provider.dart';

class RegPage extends StatefulWidget {
  const RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController password = TextEditingController();
  late Timer timer;
  String country = '';
  String state = '';
  String city = '';
  bool isLogin = false;

  late var DeviceInfo;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  void push() async {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser!.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        print('################ VERIFIED #################');
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateAccount(
                    city: city,
                    country: country,
                    state: state,
                    email: emailAddress.text,
                    password: password.text,
                  ),
            ));
        timer.cancel();
      }
    });
  }
  @override
  void initState() {
    getLocationPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme
        .of(context)
        .platform;
    bool darkMode = Provider
        .of<VarProvider>(context)
        .darkMode;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor:
          darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: currentPlatform == TargetPlatform.android
                ? Icon(
              Icons.arrow_back,
              color: darkMode ? Colors.white : Colors.black,
            )
                : Icon(
              Icons.arrow_back_ios,
              color: darkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        backgroundColor:
        darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
            elevation: 0,
            onPressed: () async {
              await registration(context, darkMode);
            },
            backgroundColor:
            darkMode ? const Color(0xff47555E) : const Color(0xff7AA5D2),
            child: Icon(
              TargetPlatform.android == currentPlatform
                  ? Icons.arrow_forward
                  : Icons.arrow_forward_ios,
              color: Colors.white,
            )),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                top: MediaQuery
                    .sizeOf(context)
                    .height * .1,
                bottom: MediaQuery
                    .sizeOf(context)
                    .height * .05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Your email address',
                          style: TextStyle(
                              color: darkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    const Text(
                      '\nPlease confirm your country and',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const Text(
                      'enter your email address.',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = true;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 30, right: 10),
                        height: 50,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            color: darkMode
                                ? (isLogin
                                ? Colors.blue.shade800
                                : Colors.blue.shade500.withOpacity(0.2))
                                : isLogin
                                ? Colors.blue.shade300
                                : Colors.blue.shade100),
                        child: Center(
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                                color: isLogin
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = false;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 30),
                        height: 50,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            color: darkMode
                                ? (isLogin
                                ? Colors.blue.shade500.withOpacity(0.2)
                                : Colors.blue.shade800)
                                : isLogin
                                ? Colors.blue.shade100
                                : Colors.blue.shade300),
                        child: Center(
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                                color: isLogin
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: emailAddress,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                        hintText: 'example@gmail.com',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.blue)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.blue)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: password,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'at least 6 characters',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.blue)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.blue)),
                      ),
                    ),
                  ),
                ),
                if (!isLogin)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: CSCPicker(
                      dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color:
                          darkMode ? Colors.grey.shade800 : Colors.white),
                      disabledDropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color:
                          darkMode ? Colors.grey.shade800 : Colors.white),
                      defaultCountry: CscCountry.Uzbekistan,
                      layout: Layout.vertical,
                      onCountryChanged: (value) {
                        country = value;
                      },
                      onStateChanged: (value) {
                        if (value != null) {
                          setState(() {
                            state = value;
                          });
                        }
                      },
                      onCityChanged: (value) {
                        if (value != null) {
                          setState(() {
                            city = value;
                          });
                        }
                      },
                    ),
                  ),
                if (isLogin)
                  TextButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailAddress.text);
                        showCupertinoModalPopup1(context,
                            "We have sent a confirmation link to your email, please check your email.",
                            true);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar( behavior: SnackBarBehavior.floating,
                            backgroundColor: darkMode
                                ? Colors.red.shade900
                                : Colors.red.shade200,
                            content: Text(
                              e.toString().split(']')[1],
                              style: const TextStyle(color: Colors.white),
                            )));
                      }
                    },
                    child: const Text(
                      'Reset password',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registration(BuildContext context, bool darkMode) async {
    if (!isLogin && state == '') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar( behavior: SnackBarBehavior.floating,
          backgroundColor: darkMode ? Colors.red.shade900 : Colors.red.shade200,
          content: const Text(
            'Choose a location!',
            style: TextStyle(color: Colors.white),
          )));
    } else {
      try {
        if (isLogin) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailAddress.text.trim(),
                password: password.text.trim()).whenComplete((){
            getDeviceInfo().whenComplete((){
              if(TargetPlatform.iOS==defaultTargetPlatform){
                API.updateIosInfo(DeviceInfo);
              }else{
                API.updateAndroidInfo(DeviceInfo);
              }
            });
          });

          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),);
        } else {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailAddress.text.trim(),
                password: password.text.trim());
            await FirebaseAuth.instance.currentUser?.sendEmailVerification();
            showCupertinoModalPopup1(context,
                "We have sent a confirmation link to your email, please check your email.",
                false);
            push();
        }
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar( behavior: SnackBarBehavior.floating,
            content: const Text(
              "Oops!\nSomething went wrong. Please try again.",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor:
            darkMode ? Colors.red.shade900 : Colors.red.shade200,
          ),
        );
      }
    }
  }

  Future<dynamic> showCupertinoModalPopup1(BuildContext context, String text,
      bool isReset) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) =>
          Scaffold(
            backgroundColor: Colors.transparent.withOpacity(0.6),
            body: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(''),
                      Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(
                            height: 25,
                          ),
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 2),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          if (!isReset) {await FirebaseAuth.instance.currentUser!
                              .delete();}
                        },
                        child: Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(15)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Go back',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
    );
  }


  getLocationPermission() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

  }

  Future<void> getDeviceInfo()async{
    if(TargetPlatform.iOS==defaultTargetPlatform){
      DeviceInfo = await deviceInfo.iosInfo;
    }else{
      DeviceInfo = await deviceInfo.androidInfo;
    }
  }}
