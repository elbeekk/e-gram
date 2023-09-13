import 'dart:async';
import 'package:elbekgram/api/api.dart';
import 'package:elbekgram/chats/chatpage.dart';
import 'package:elbekgram/messagemodel.dart';
import 'package:elbekgram/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:elbekgram/chats/menu_drawer.dart';
import 'package:elbekgram/var_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late Timer timer;
  Message? message;

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
        key: _key,
        drawer: const MyDrawer(),
        backgroundColor:
            darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor:
              darkMode ? const Color(0xff47555E) : const Color(0xff7AA5D2),
          title: const Text('Elbekgram'),
          leading: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _key.currentState!.openDrawer(),
              child: const Icon(Icons.menu)),
          actions: [
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(right: width * .05, left: width * .05),
                child: const Icon(Icons.search),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            API.singOut;
          },
          elevation: 0,
          backgroundColor:
              darkMode ? const Color(0xff47555E) : const Color(0xff7AA5D2),
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
        body: StreamBuilder(
          stream: API.getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(''),
                  SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.4,
                      child: Lottie.asset('assets/welcomel.json')),
                  Column(
                    children: [
                      Text(
                        'Welcome to Elbekgram',
                        style: TextStyle(
                            color: darkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Text(
                          'Start messaging by tapping the pencil button in the bottom right corner.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    ],
                  ),
                  const Text(''),
                ],
              ));
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                UserModel user = UserModel.fromJson(snapshot.data!.docs[index]);
                return InkWell(
                  autofocus: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          uid: user.uid,
                          userModel: user,
                        ),
                      ),
                    );
                  },
                  child: mesORemail(user, darkMode),
                );
              },
            );
          },
        ));
  }



  Widget mesORemail(UserModel user, bool darkMode) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                NetworkImage(user.userImages[user.userImages.length - 1]),
                radius: 25,
                backgroundColor: Colors.white,
              ),
              title: Text("${user.userFName} ${user.userLName}"),
              subtitle: Text(
                user.userEmail,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Customshape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height);
    path.lineTo(width, height);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
