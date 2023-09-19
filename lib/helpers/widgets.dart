import 'package:elbekgram/helpers/api.dart';
import 'package:elbekgram/models/usermodel.dart';
import 'package:elbekgram/pages/reg_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../var_provider.dart';

class Widgets{
  static void snackBar(BuildContext context, bool darkMode, IconData icon,
      String text, bool isRed) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: isRed
            ? darkMode
            ? Colors.red.shade900
            : Colors.red.shade200
            : darkMode
            ? const Color(0xff47555E)
            : const Color(0xff7AA5D2),
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width*0.7,
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            )
          ],
        )));
  }

  static Future<dynamic> showModalPopup(BuildContext context, String text) {
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
}

class AccountSwitcher extends StatefulWidget {
  final String name;
  final UserModel me;
  const AccountSwitcher({super.key,required this.me,required this.name});

  @override
  State<AccountSwitcher> createState() => _AccountSwitcherState();
}

class _AccountSwitcherState extends State<AccountSwitcher> {
  double turns1 = 1;
  static bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return  Column(
      children: [
        GestureDetector(
          onTap: () {
            if (isOpen) {
              setState(() {
                turns1 -= .5;
                isOpen = false;
              });
            } else {
              setState(() {
                turns1 += .5;
                isOpen = true;
              });
            }
          },

          child: Container(
            padding:  const EdgeInsets.fromLTRB(15,0,0, 0),
            height: 60,
            decoration: BoxDecoration(
              color: darkMode
                  ? const Color(0xff47555E)
                  : const Color(0xff7AA5D2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(API.currentUserAuth()?.email ?? '',overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey.shade100),),
                ],),
                Spacer(),
                InkWell(
                  onTap: () {
                    if (isOpen) {
                      setState(() {
                        turns1 -= .5;
                        isOpen = false;
                      });
                    } else {
                      setState(() {
                        turns1 += .5;
                        isOpen = true;
                      });
                    }
                  },
                  child: AnimatedRotation(
                    curve: Curves.easeOutExpo,
                    duration: const Duration(milliseconds:600 ),
                    turns: turns1,
                    child: Transform.rotate(
                        angle: 3.14 / 2,
                        child:  const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 19,
                          ),
                        )),
                  ),
                ),
                const SizedBox(width: 10,)
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds:300),
        height:  isOpen?115:0,
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child:  ListTile(
                    leading: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: width*0.048,
                          backgroundImage: NetworkImage(widget.me.userImages[widget.me.userImages.length-1]),
                          backgroundColor: Colors.white,
                        ),
                        Positioned(
                            bottom: -3,
                            right: -3,
                            child: CircleAvatar(radius: 8.2,backgroundColor: Colors.white,
                                child: Center(child: Icon(Icons.check_circle,color: darkMode ? Colors.blueAccent:Colors.green,size: 17,))))
                      ],
                    ),
                    title: Text("${widget.me.userFName} ${widget.me.userLName}"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegPage(),));
                  },
                  child:  ListTile(
                    leading: CircleAvatar(
                      radius: width*0.048,
                      backgroundColor: darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
                    child: const Icon(Icons.add,color: Colors.grey,),
                    ),
                    title: const Text("Add Account"),
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          height: 5,
          indent: 0,
          thickness: darkMode ? 0: 1,
          endIndent: 0,
          color:darkMode ? const Color(0xff000409):Colors.grey.shade300,
        ),
      ],
    );
  }
}

class DarkModeSwitcher extends StatefulWidget {
  const DarkModeSwitcher({super.key});

  @override
  State<DarkModeSwitcher> createState() => _DarkModeSwitcherState();
}

class _DarkModeSwitcherState extends State<DarkModeSwitcher> {
  double turns = 1;
  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    return Row(
      children: [
        InkWell(
          onTap: (){
            if (darkMode) {
              setState(() => turns -= 1 / 4);
            } else {
              setState(() => turns += 1 / 4);
            }
            Provider.of<VarProvider>(context, listen: false)
                .changeMode(darkMode);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:7),
            child: AnimatedRotation(
                curve: Curves.easeOutExpo,
                turns: turns,
                duration: const Duration(seconds: 5),
                child: darkMode
                    ? const Icon(
                  Icons.sunny,
                  color: Colors.white,
                  size: 30,
                )
                    : const Icon(
                  Icons.dark_mode,
                  color: Colors.white,
                  size: 30,
                )),
          ),
        ),
        const SizedBox(width: 5,)
      ],
    );

  }
}



