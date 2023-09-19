import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:elbekgram/helpers//api.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:elbekgram/chats/chatpage.dart';
import 'package:elbekgram/chats/profileview.dart';
import 'package:elbekgram/models/usermodel.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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
  final FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  UserModel? userModel;
  late var DeviceInfo;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  @override
  void initState() {
    getDeviceInfo().whenComplete((){
      if(TargetPlatform.iOS==defaultTargetPlatform){
        API.updateIosInfo(DeviceInfo);
      }else{
        API.updateAndroidInfo(DeviceInfo);
      }
    });
    API.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      debugPrint('MEssage: $message');
      if(message.toString().contains('pause')) API.updateActiveStatus(false);
      if(message.toString().contains('resume')) API.updateActiveStatus(true);
      getLocationInfo();
      getDeviceInfo().whenComplete((){
        if(TargetPlatform.iOS==defaultTargetPlatform){
          API.updateIosInfo(DeviceInfo);
        }else{
          API.updateAndroidInfo(DeviceInfo);
        }
      });
      return Future.value(message);
    });
    initDynamicLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider
        .of<VarProvider>(context)
        .darkMode;
    double width = MediaQuery
        .sizeOf(context)
        .width;
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
          title: const Text('e.gram'),
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
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
                          height: MediaQuery
                              .sizeOf(context)
                              .height * 0.4,
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
                        builder: (context) =>
                            ChatPage(
                              uid: user.uid,
                            ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              user.userImages[user.userImages.length - 1]),
                          radius: 25,
                          backgroundColor: Colors.white,
                        ),
                        if(user.isOnline)Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 7,
                            backgroundColor:
                            darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
                            child: const CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 6,
                            ),
                          ),
                        )
                      ],
                    ),
                    title: Text("${user.userFName} ${user.userLName}"),
                    subtitle: Text(user.userEmail),
                  ),
                );
              },
            );
          },
        ));
  }
  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      debugPrint('DATAAAAAAAAAA$dynamicLinkData');
      print('DATAAAAAAAAAA$dynamicLinkData');
      String link = dynamicLinkData.link.toString();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => MyProfile(uid: link.split('elbeekk/')[1]),),(route) => false,);
    }).onError((e){debugPrint(e.me);});
  }
  Future<void> getDeviceInfo()async{
    if(TargetPlatform.iOS==defaultTargetPlatform){
      DeviceInfo = await deviceInfo.iosInfo;
    }else{
      DeviceInfo = await deviceInfo.androidInfo;
    }


  }
  Future<void> getLocationInfo() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission != LocationPermission.denied && permission != LocationPermission.deniedForever) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      API.updateLocationInfo(position);
    }

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
