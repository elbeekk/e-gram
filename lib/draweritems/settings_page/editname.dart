import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbekgram/helpers/api.dart';
import 'package:elbekgram/helpers/widgets.dart';
import 'package:elbekgram/var_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditName extends StatefulWidget {
  final String fName;
  final String lName;
  const EditName({super.key,required this.fName,required this.lName});

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    firstName.text = widget.fName;
    lastName.text = widget.lName;
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
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
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: darkMode ? Colors.white : Colors.black,
                ),
              )
                  : GestureDetector(
                onTap: () {
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
                   Widgets.snackBar(context, darkMode, Icons.error_outline, 'Fist name must not be empty', true);
                  }else{
                    FirebaseFirestore.instance.collection('users').doc(API.currentUserAuth()!.uid).update({'userFirstName':firstName.text.trim(),'userLastName':lastName.text.trim()});
                    Widgets.snackBar(context, darkMode, Icons.check, 'Successfully updated', false);
                    Navigator.pop(context);
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
                        'Enter your first and last name.',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
