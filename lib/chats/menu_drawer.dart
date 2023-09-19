import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbekgram/draweritems/settings_page/mysettings.dart';
import 'package:elbekgram/helpers/api.dart';
import 'package:elbekgram/helpers/widgets.dart';
import 'package:elbekgram/models/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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


  late UserModel user;
  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    return Drawer(
      backgroundColor:
          darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
      child: StreamBuilder(
        stream: API.getAllUsers(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          for (var i in snapshot.data!.docs){
            if(i.id==API.currentUserAuth()!.uid){
              user = UserModel.fromJson(i);
            }
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding:  EdgeInsets.fromLTRB(15, height*.075 , 0, 0),
                  height: height * 0.2,
                  decoration: BoxDecoration(
                    color:
                    darkMode
                        ? const Color(0xff47555E)
                        : const Color(0xff7AA5D2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap:() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const MySettings(),));
                            },
                            child: CircleAvatar(
                              radius: height*0.043,
                              backgroundImage: NetworkImage(user.userImages[user.userImages.length-1]),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DarkModeSwitcher(),
                        ],
                      ),
                    ],
                  ),
                ),
                AccountSwitcher(me: user,name: "${user.userFName} ${user.userLName}",),

                MyDrawerItem(darkMode: darkMode, title: 'My Stories', icon: MaterialCommunityIcons.play_box_multiple_outline,route: const MyStories(),),
                Divider(
                  height: 5,
                  thickness: darkMode ? 0: 1,
                  indent: 0,
                  endIndent: 0,
                  color: darkMode ? const Color(0xff000409):Colors.grey.shade300,
                ),
                MyDrawerItem(darkMode: darkMode, title:'New Group', icon: Icons.people_alt_outlined),
                MyDrawerItem(darkMode: darkMode, title:'Contacts', icon: Icons.person_2_outlined,route: const MyContacts(),),
                MyDrawerItem(darkMode: darkMode, title:'Calls', icon: Ionicons.call_outline,route: const MyCalls(),),
                MyDrawerItem(darkMode: darkMode, title:'People Nearby', icon: Icons.location_on_outlined),
                MyDrawerItem(darkMode: darkMode, title:'Saved Messages', icon: Icons.bookmark_border),
                MyDrawerItem(darkMode: darkMode, title:'Settings', icon: Ionicons.settings_outline,route: const MySettings(),),
                Divider(
                  height: 5,
                  indent: 0,
                  thickness: darkMode ? 0: 1,
                  endIndent: 0,
                  color:darkMode ? const Color(0xff000409):Colors.grey.shade300,
                ),
                MyDrawerItem(darkMode: darkMode, title:'Invite Friends', icon: Ionicons.person_add_outline),
                MyDrawerItem(darkMode: darkMode, title:'Telegram Features', icon: MaterialCommunityIcons.progress_question),

              ],
            ),
          );
        },


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
    required this.darkMode,
    required this.title,
    required this.icon,
    this.route,
  });

  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (route != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => route,
              ));
        }
      },
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Icon(
                icon,
                color: Colors.grey,
              ),
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
