import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:elbekgram/var_provider.dart';

class MyStories extends StatefulWidget {
  const MyStories({super.key});

  @override
  State<MyStories> createState() => _MyStoriesState();
}

class _MyStoriesState extends State<MyStories> {
  int currentIndex = 0;
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor:
      darkMode
          ? const Color(0xff303841)
          : const Color(0xffEEEEEE),
      appBar: AppBar(
        elevation: .7,
        backgroundColor: darkMode
            ? const Color(0xff47555E)
            : const Color(0xff7AA5D2),
        leading: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.pop(context);
          },
          child: currentPlatform == TargetPlatform.android
              ? const Icon(
                  Icons.arrow_back,
                  color:  Colors.white ,
                )
              : const Icon(
                  Icons.arrow_back_ios,
                  color:  Colors.white ,
                ),
        ),
        title: Text(
          currentIndex == 0 ? 'My Stories' : 'Story Archive',
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: darkMode ? Colors.white : Colors.black,
        selectedIconTheme: IconThemeData(color: darkMode ? Colors.white : Colors.black),
        unselectedIconTheme: IconThemeData(color: darkMode ? Colors.grey.withOpacity(.6): Colors.black.withOpacity(.5)),
        unselectedItemColor:  darkMode ? Colors.grey.withOpacity(.6):Colors.black.withOpacity(.5),
        selectedFontSize: 13,
        unselectedFontSize: 13,
        backgroundColor:
            darkMode ? Colors.blueGrey.shade900 : Colors.grey.shade50,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
          controller.jumpToPage(currentIndex);
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Container(
              height: 30,
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(15)),
              child: const Icon(
                MaterialCommunityIcons.progress_check,
              ),
            ),
            backgroundColor: darkMode ? Colors.blue : Colors.grey.shade50,
            icon: const SizedBox(
              height: 30,
              width: 60,
              child: Icon(
                MaterialCommunityIcons.progress_check,
              ),
            ),
            label: 'Posted',
          ),
          BottomNavigationBarItem(
              activeIcon: Container(
                height: 30,
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(15)),
                child: const Icon(
                  MaterialCommunityIcons.progress_clock,
                ),
              ),
              icon: const SizedBox(
                height: 30,
                width: 60,
                child: Icon(
                  MaterialCommunityIcons.progress_clock,
                ),
              ),
              label: 'Archive')
        ],
      ),
      body: PageView(
        controller: controller,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        children: [
          Scaffold(
            backgroundColor:
            darkMode
                ? const Color(0xff303841)
                : const Color(0xffEEEEEE),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: height * 0.4,
                      child: Lottie.asset('assets/mystr.json')),
                  Column(
                    children: [
                      Text(
                        'No public stories',
                        style: TextStyle(
                            color: darkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 7),
                        child: Text(
                          "Open the 'Archive' tab to select stories you want to be displayed on your profile.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.blueGrey.shade400, fontSize: 14),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor:darkMode
                  ? const Color(0xff47555E)
                  : const Color(0xff7AA5D2),
              onPressed: () {},
              elevation: 0,
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
            backgroundColor:
            darkMode
                ? const Color(0xff303841)
                : const Color(0xffEEEEEE),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: height * 0.4,
                      child: Lottie.asset('assets/myarchive.json')),
                  Column(
                    children: [
                      Text(
                        'No stories yet...',
                        style: TextStyle(
                            color: darkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 7),
                        child: Text(
                          "Upload a new story to view it here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.blueGrey.shade400, fontSize: 14),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
