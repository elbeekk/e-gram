import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbekgram/usermodel.dart';
import 'package:elbekgram/var_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  final String title;
  final UserModel user;
  final String info;
  final TextEditingController controller;

  const EditPage(
      {super.key,
      required this.title,
      required this.user,
      required this.info,
      required this.controller
      });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Future<dynamic> showCupertinoModalPopup1(BuildContext context, String text) {
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

  void push() async {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser!.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        await FirebaseFirestore.instance.collection('users').doc(
            widget.user.uid).update({'userEmail': widget.controller.text.trim()});
        print('################ VERIFIED #################');
        Navigator.pop(context);
        Navigator.pop(context);

        timer.cancel();
      }
    });
  }
  String? tempEmail = '';
  late Timer timer;
  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    widget.controller.text=widget.info;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor:
            darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
          backgroundColor:
              darkMode ? const Color(0xff47555E) : const Color(0xff7AA5D2),
          actions: [
            GestureDetector(
             onTap: ()async {
               if(widget.title=='Bio'){
                 FirebaseFirestore.instance.collection('users').doc(widget.user.uid).update({'userBio':widget.controller.text});
                 Navigator.pop(context);
               }
               if(widget.title=='Email'){
                 tempEmail= FirebaseAuth.instance.currentUser!.email;
                   try{
                     if(FirebaseAuth.instance.currentUser!.email!=widget.controller.text.trim()){
                       await FirebaseAuth.instance.currentUser!.updateEmail(
                           widget.controller.text.trim());
                       await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                       showCupertinoModalPopup1(context, 'We have sent a confirmation link to your new email, please check your email.');
                       push();

                     }else{
                       Navigator.pop(context);
                     }


                   }catch(e){
                     showSnackBar1(context, darkMode, e);
                   }
                   // showCupertinoModalPopup1(context, 'We have sent a confirmation link to your email, please check your email.');
                   // Navigator.pop(context);
                 }

             },
              child: const SizedBox(
                width: 50,
                child: Icon(
                  Icons.done,
                  size: 28,
                ),
              ),
            )
          ],
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: currentPlatform == TargetPlatform.android
                ? Icon(
                    Icons.arrow_back,
                    color: darkMode ? Colors.white : Colors.white,
                  )
                : Icon(
                    Icons.arrow_back_ios,
                    color: darkMode ? Colors.white : Colors.white,
                  ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                autofocus: true,
                controller: widget.controller,
                keyboardAppearance: darkMode? Brightness.dark: Brightness.light,
                keyboardType: TextInputType.text,

              ),
            )
          ],
        ),
      ),
    );
  }

  void showSnackBar1(BuildContext context, bool darkMode, Object e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar( behavior: SnackBarBehavior.floating,
        backgroundColor: darkMode
            ? Colors.red.shade900
            : Colors.red.shade200,
        content: Text(
          e.toString().split(']')[1],
          style: const TextStyle(color: Colors.white),
        )));
  }
}
