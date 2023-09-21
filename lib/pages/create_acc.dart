import 'dart:io';
import 'package:elbekgram/helpers/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:elbekgram/chats/homepage.dart';
import 'package:elbekgram/var_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccount extends StatefulWidget {
  final String city;
  final String country;
  final String state;
  final String email;
  final String password;

  const CreateAccount(
      {super.key,
      required this.city,
      required this.country,
      required this.state, required this.email, required this.password});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}
class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  XFile? image;
  String link = '';
  bool isDone=false;
  bool isStart=false;


  createAc() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid.toString()).collection('user_info').doc('devices').set(
        {
          'devices':[],
          'token':[],
        });
    var users = FirebaseFirestore.instance.collection('users').doc(uid.toString());
    users.update({
      'chattingWith':[uid.toString()],
      'country': widget.country,
      'state': widget.state,
      'city': widget.city,
      'uid': uid,
      'userBio': '',
      'userEmail':widget.email,
      'userFirstName': firstName.text,
      'password': widget.password,
      'isOnline':true,
      'lastActive':DateTime.now().millisecondsSinceEpoch.toString(),
      'userLastName': lastName.text,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor:
        darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
        body: SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor:
            darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
            appBar: AppBar(
              leading: TargetPlatform.android == currentPlatform
                  ? GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.currentUser!.delete();
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: darkMode ? Colors.white : Colors.black,
                      ),
                    )
                  : GestureDetector(
                      onTap: () async{
                        await FirebaseAuth.instance.currentUser!.delete();
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: darkMode ? Colors.white : Colors.black,
                      ),
                    ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (firstName.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar( behavior: SnackBarBehavior.floating,
                        content: const Text(
                          'First name is required',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: darkMode
                            ? Colors.red.shade900
                            : Colors.red.shade200,
                      ),
                    );
                  } else {
                    if (isDone) {
                      showDialog(
                        context: context,
                        barrierColor: null,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            backgroundColor: darkMode
                                ? const Color(0xff395781)
                                : Colors.grey.shade50,
                            shadowColor: Colors.black,
                            content: Text(
                              'Close this window and continue registration))',
                              style: TextStyle(
                                  color: darkMode ? Colors.white : Colors.black,
                                  fontSize: 15),
                            ),
                            title: Text(
                              'Terms of Service',
                              style: TextStyle(
                                  color: darkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                            actions: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Disagree',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  createAc();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  const HomePage(),
                                      ),
                                      (route) => false);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Agree',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar( behavior: SnackBarBehavior.floating,
                        content: const Text('Please pick an image for profile photo'),
                        backgroundColor: darkMode
                            ? Colors.red.shade900
                            : Colors.red.shade200,
                      ));
                    }
                  }
                },
                backgroundColor:
                darkMode ? const Color(0xff47555E) : const Color(0xff7AA5D2),
                elevation: 0,
                child: TargetPlatform.android == currentPlatform
                    ? const Icon(Icons.arrow_forward,color: Colors.white,)
                    : const Icon(Icons.arrow_forward_ios,color: Colors.white,)),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height*0.1,bottom: MediaQuery.sizeOf(context).height*0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(''),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            barrierColor: null,
                            context: context,
                            builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                backgroundColor: darkMode
                                    ? const Color(0xff395781)
                                    : Colors.grey.shade50,
                                shadowColor: Colors.black,
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Select source',
                                      style: TextStyle(
                                          color: darkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w400,fontSize: 18),
                                    ),
                                  ],
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: ()  {
                                            setState(() {
                                              isStart=true;
                                            });
                                            Navigator.pop(context);
                                            API.uploadImageInit(ImageSource.camera, darkMode, context, ).whenComplete((){setState(() {
                                              isStart=false;
                                              isDone=true;
                                            });});
                                            },
                                          child: const Text(
                                            'Camera',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              isStart=true;
                                            });
                                            Navigator.pop(context);
                                            API.uploadImageInit(ImageSource.gallery, darkMode, context,).whenComplete(() {setState(() {
                                              isDone=true;
                                              isStart=false;
                                            });});
                                            },
                                          child: const Text(
                                            'Gallery',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          );
                        },
                        child: CircleAvatar(
                            radius: 40,
                            backgroundColor:
                            darkMode ? const Color(0xff47555E) : const Color(0xff7AA5D2),
                            child:!isStart ?  !isDone
                                ? const Icon(
                              MaterialCommunityIcons.camera_plus,
                              size: 30,
                              color: Colors.white,
                            ): const Icon(
                              MaterialCommunityIcons.check,
                              size: 60,
                              color: Colors.white,
                            ) :const CircularProgressIndicator(color: Colors.white,)




                                ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Profile info',
                        style: TextStyle(
                          color: darkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Enter your name and add a profile photo',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextField(
                          keyboardAppearance: darkMode ? Brightness.dark:Brightness.light,
                          controller: firstName,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(fontSize: 15),
                              labelText: 'First name (required)',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.5)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.blue))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextField(
                          keyboardAppearance: darkMode ? Brightness.dark:Brightness.light,
                          controller: lastName,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              labelText: 'Last name (optional)',
                              labelStyle: const TextStyle(fontSize: 15),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.5)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.blue))),
                        ),
                      ),
                    ],
                  ),
                  const Text(''),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height*0.29,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'By signing up, you agree',
                              style: TextStyle(
                                  color: Colors.grey.withOpacity(0.8),
                                  fontSize: 13),
                            ),
                            RichText(
                                text: TextSpan(
                                    text: 'to the ',
                                    style: TextStyle(
                                        color: Colors.grey.withOpacity(0.8),
                                        fontSize: 13),
                                    children: [
                                  TextSpan(
                                      text: 'Terms of Service',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => showDialog(
                                              context: context,
                                              barrierColor: null,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  backgroundColor: darkMode
                                                      ? const Color(0xff395781)
                                                      : Colors.grey.shade50,
                                                  shadowColor: Colors.black,
                                                  content: Text(
                                                    'Close this window and continue registration))',
                                                    style: TextStyle(
                                                        color: darkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 15),
                                                  ),
                                                  title: Text(
                                                    'Terms of Service',
                                                    style: TextStyle(
                                                        color: darkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 20),
                                                  ),
                                                  actions: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 13))
                                ]))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
