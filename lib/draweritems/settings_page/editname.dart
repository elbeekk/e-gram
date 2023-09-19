import 'package:elbekgram/helpers/widgets.dart';
import 'package:elbekgram/var_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditName extends StatefulWidget {
  const EditName({super.key});

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                                          text: 'Tems of Service',
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
