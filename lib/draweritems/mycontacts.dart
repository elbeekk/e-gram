import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbekgram/chats/profileview.dart';
import 'package:elbekgram/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:elbekgram/var_provider.dart';

class MyContacts extends StatefulWidget {
  const MyContacts({super.key});

  @override
  State<MyContacts> createState() => _MyContactsState();
}

bool sortByTime = false;

class _MyContactsState extends State<MyContacts> {
  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor:
          darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          elevation: 0,
          backgroundColor:
              darkMode ? const Color(0xff47555E) : const Color(0xff7AA5D2),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Ionicons.person_add,
                size: 20,
                color: Colors.white,
              ),
              SizedBox(
                height: 4,
              )
            ],
          )),
      appBar: AppBar(
        elevation: .7,
        backgroundColor:
            darkMode ? const Color(0xff47555E) : const Color(0xff7AA5D2),
        leading: InkWell(
          borderRadius: BorderRadius.circular(20),
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
        actions: [
          InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: SizedBox(
                  width: width * 0.1,
                  child: const Center(child: Icon(Ionicons.search_outline)))),
          const SizedBox(
            width: 17,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() {
                sortByTime = !sortByTime;
              });
            },
            child: Container(
              padding: const EdgeInsets.only(right: 20, left: 7),
              child: Center(
                child: Stack(
                  children: [
                    const Icon(Icons.sort),
                    Positioned(
                        bottom: 2,
                        right: 1,
                        child: sortByTime
                            ? const Icon(
                                MaterialCommunityIcons.clock,
                                size: 10,
                              )
                            : const Text(
                                'A',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ))
                  ],
                ),
              ),
            ),
          ),
        ],
        title: Text(
          "Contacts",
          style: TextStyle(
              color: darkMode ? Colors.white : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {},
            child: SizedBox(
              height: 50,
              width: width,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Icon(
                      Ionicons.person_add_outline,
                      color: Colors.grey,
                      size: 22,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    'Invite Friends',
                    style: TextStyle(
                        color: darkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ))
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: SizedBox(
              height: 55,
              width: width,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                      child: Text('Find People Nearby',
                          style: TextStyle(
                              color: darkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 16)))
                ],
              ),
            ),
          ),
          Container(
            height: 14,
            width: width,
            color: darkMode
                ? Colors.grey.shade800.withOpacity(.26)
                : Colors.grey.shade300.withOpacity(.5),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('contacts')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data!.docs.isEmpty) {
                return Expanded(
                    child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * .4,
                        child: Lottie.asset('assets/nocontacts.json'),
                      ),
                      Text(
                        'You have no contacts on Elbekgram yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: darkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Opacity(
                                  opacity: .5,
                                  child: Text(
                                    "⚫",
                                    style: TextStyle(
                                      fontSize: 5,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Invite friends to try Elbekgram',
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade300),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Opacity(
                                  opacity: .5,
                                  child: Text(
                                    "⚫",
                                    style: TextStyle(
                                      fontSize: 5,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Find people nearby to chat with',
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade300),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Opacity(
                                  opacity: .5,
                                  child: Text(
                                    "⚫",
                                    style: TextStyle(
                                      fontSize: 5,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Search people by username',
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade300),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
              } else{
                return Expanded(
                  child: SizedBox(
                    width: width,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        UserModel user =
                        UserModel.fromJson(snapshot.data!.docs[index]);
                        return InkWell(
                          autofocus: true,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile(uid: user.uid),));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  user.userImages[user.userImages.length - 1]),
                              radius: 25,
                              backgroundColor: Colors.white,
                            ),
                            title: Text("${user.userFName} ${user.userLName}"),
                            subtitle: Text(user.userEmail),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }

            },
          )
        ],
      ),
    );
  }
}
