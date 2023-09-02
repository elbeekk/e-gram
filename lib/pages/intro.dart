import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elbekgram/pages/reg_page.dart';
import 'package:elbekgram/var_provider.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  double turns = 1;
  PageController pageCon = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    return Scaffold(
      backgroundColor: darkMode
          ? Colors.blue.shade200.withOpacity(0.2)
          : Colors.grey.shade50,
      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //changing modes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(''),
                  GestureDetector(
                      onTap: () {
                        if (darkMode) {
                          setState(() => turns -= 1 / 4);
                        } else {
                          setState(() => turns += 1 / 4);
                        }
                        Provider.of<VarProvider>(context, listen: false)
                            .changeMode(darkMode);
                      },
                      child: AnimatedRotation(
                          curve: Curves.easeOutExpo,
                          turns: turns,
                          duration: const Duration(seconds: 2),
                          child: Container(
                            child: darkMode
                                ? const Icon(
                                    Icons.sunny,
                                    color: Colors.blue,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.dark_mode,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                          ))),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: PageView(
                      onPageChanged: (value) => setState(() {
                        currentPage = value;
                      }),
                      controller: pageCon,
                      scrollDirection: Axis.horizontal,
                      children: [
                        infos(
                          title: 'Telegram',
                          subtitle1: "The world's fastest messaging app.",
                          subtitle2: "It is free and secure",
                          darkMode: darkMode,
                        ),
                        infos(
                          title: 'Fast',
                          subtitle1: "Telegram delivers messages faster than",
                          subtitle2: "any other application",
                          darkMode: darkMode,
                        ),
                        infos(
                          title: 'Free',
                          subtitle1:
                              "Telegram provides free unlimited cloud storage for",
                          subtitle2: "chats and media",
                          darkMode: darkMode,
                        ),
                        infos(
                          title: 'Powerful',
                          subtitle1: "Telegram has no limits on",
                          subtitle2: "the size of your media and chats",
                          darkMode: darkMode,
                        ),
                        infos(
                          title: 'Secure',
                          subtitle1: "Telegram keeps your messages safe",
                          subtitle2: "from hacker attacks",
                          darkMode: darkMode,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 7),
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? Colors.blue
                                : Colors.grey),
                      );
                    }),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegPage(),
                    ),
                    (route) => false,
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 70),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                      child: Text(
                    'Start Messaging',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class infos extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final bool darkMode;

  const infos(
      {super.key,
      required this.title,
      required this.subtitle1,
      required this.subtitle2,
      required this.darkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              color: darkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 30),
        ),
        Text(
          "\n$subtitle1\n$subtitle2\n",
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ],
    );
  }
}
