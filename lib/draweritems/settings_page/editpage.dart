import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbekgram/helpers/widgets.dart';
import 'package:elbekgram/models/usermodel.dart';
import 'package:elbekgram/var_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/api.dart';

class EditPage extends StatefulWidget {
  final String info;
  final bool isBio;
  const EditPage(
      {super.key,
      required this.info, required this.isBio,
      });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {


  TextEditingController controller = TextEditingController();
  String? tempEmail = '';
  late Timer timer;
  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    controller.text=widget.info;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor:
            darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
        appBar: AppBar(
          title: Text(widget.isBio ? 'Bio' : 'Email'),
          elevation: 0,
          backgroundColor:
              darkMode ? const Color(0xff47555E) : const Color(0xff7AA5D2),
          actions: [
            GestureDetector(
             onTap: ()async {
               if(widget.isBio){
                 FirebaseFirestore.instance.collection('users').doc(API.currentUserAuth()!.uid).update({'userBio':controller.text});
                 Navigator.pop(context);
               }else{
                   try{
                     if(API.currentUserAuth()!.email!=controller.text.trim()){
                       tempEmail= API.currentUserAuth()!.email;
                       await API.currentUserAuth()!.updateEmail(
                           controller.text.trim());
                       try{
                         API.currentUserAuth()!.sendEmailVerification();
                          try{
                            API.verifyCurrentEmail(context, API.currentUserAuth()!.uid, controller.text.trim(),
                                true,tempEmail.toString(),);
                            Widgets.showModalPopup(context, 'We have sent a confirmation link to your new email, please check your email.');
                          }catch(e){
                            Widgets.snackBar(context, darkMode, Icons.error_outline, e.toString().split(']')[1], true);
                          }
                       }catch(e){
                         Widgets.snackBar(context, darkMode, Icons.error_outline, e.toString().split(']')[1], true);
                       }
                     }else{
                       Navigator.pop(context);
                     }
                   }catch(e){
                     Widgets.snackBar(context, darkMode, Icons.error_outline, e.toString().split(']')[1], true);
                   }
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
                controller: controller,
                keyboardAppearance: darkMode? Brightness.dark: Brightness.light,
                keyboardType: widget.isBio ? TextInputType.emailAddress:TextInputType.text,

              ),
            )
          ],
        ),
      ),
    );
  }


}
