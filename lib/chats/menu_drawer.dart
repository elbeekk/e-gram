import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:elbekgram/draweritems/mycalls.dart';
import 'package:elbekgram/draweritems/mycontacts.dart';
import 'package:elbekgram/draweritems/mystories.dart';
import 'package:elbekgram/var_provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  double turns = 1;
  double turns1 = 1;
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    return Drawer(
      backgroundColor:  darkMode
          ? const Color(0xff303841)
          : const Color(0xffEEEEEE),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:  EdgeInsets.fromLTRB(15, height*.075 , 0, 0),
              height: height * 0.25,
              decoration: BoxDecoration(
                color: darkMode
                    ? const Color(0xff47555E)
                    : const Color(0xff7AA5D2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(bottom: height*.02,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          child: Lottie.asset('assets/person.json'),
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Elbek Mirzamakhmudov',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              'elbekmirzamakhmudov@gmail.com',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        child: AnimatedRotation(
                            curve: Curves.easeOutExpo,
                            turns: turns,
                            duration: const Duration(seconds: 2),
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
                        child: Container(
                          padding:  EdgeInsets.fromLTRB(
                            height*.02,
                            height*.02,
                            height*.02,
                            height*.02,
                          ),
                          child: AnimatedRotation(
                            curve: Curves.easeOutExpo,
                            duration: const Duration(seconds: 1),
                            turns: turns1,
                            child: Transform.rotate(
                                angle: 3.14 / 2,
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
             MyDrawerItem(darkMode: darkMode, title: 'My Stories', icon: MaterialCommunityIcons.play_box_multiple_outline,route: MyStories(),),
             Divider(
              height: 5,
              indent: 0,
              endIndent: 0,
              color: darkMode ? const Color(0xff000409):Colors.grey.shade300,
            ),
            MyDrawerItem(darkMode: darkMode, title:'New Group', icon: Icons.people_alt_outlined),
            MyDrawerItem(darkMode: darkMode, title:'Contacts', icon: Icons.person_2_outlined,route: const MyContacts(),),
            MyDrawerItem(darkMode: darkMode, title:'Calls', icon: Ionicons.call_outline,route: const MyCalls(),),
            MyDrawerItem(darkMode: darkMode, title:'People Nearby', icon: Icons.location_on_outlined),
            MyDrawerItem(darkMode: darkMode, title:'Saved Messages', icon: Icons.bookmark_border),
            MyDrawerItem(darkMode: darkMode, title:'Settings', icon: Ionicons.settings_outline),
            Divider(
              height: 5,
              indent: 0,
              endIndent: 0,
              color:darkMode ? const Color(0xff000409):Colors.grey.shade300,
            ),
            MyDrawerItem(darkMode: darkMode, title:'Invite Friends', icon: Ionicons.person_add_outline),
            MyDrawerItem(darkMode: darkMode, title:'Telegram Features', icon: MaterialCommunityIcons.progress_question),

          ],
        ),
      ),
    );
  }
}

class MyDrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  var route;
  MyDrawerItem({
    super.key,
    required this.darkMode, required this.title, required this.icon, this.route,
  });

  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(route!=null){
          Navigator.push(context, MaterialPageRoute(builder: (context) => route,));
        }
      },
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Icon(icon,color: Colors.grey,),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
