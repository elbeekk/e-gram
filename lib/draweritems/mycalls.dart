import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:elbekgram/var_provider.dart';

class MyCalls extends StatelessWidget {
  const MyCalls({super.key});

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor:
      darkMode
          ? const Color(0xff303841)
          : const Color(0xffEEEEEE),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        backgroundColor: darkMode
            ? const Color(0xff47555E)
            : const Color(0xff7AA5D2),
        child: const Icon(
          Icons.call,
          color: Colors.white,
          size: 27,
        ),
      ),
      appBar: AppBar(
        elevation: .7,
        backgroundColor: darkMode
    ? const Color(0xff47555E)
        : const Color(0xff7AA5D2),
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
        title: Text(
          "Calls",
          style: TextStyle(
              color: darkMode ? Colors.white : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: height * .4,
                  child: Lottie.asset('assets/mycalls.json'),
                ),
                Positioned(
                  left: width*0.22,
                    right: width*0.236,
                    bottom: height*0.055,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.orange.shade400,borderRadius: BorderRadius.circular(25)),
                  height: height * 0.017,
                ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'No recent calls',
              style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 65),
              child: Text(
                'Your recent voice and video callas will appear here.',
                style: TextStyle(color: Colors.blueGrey.shade300),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
