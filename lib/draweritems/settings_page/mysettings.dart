import 'dart:io';
import 'package:dio/dio.dart';
import 'package:elbekgram/api/api.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:animations/animations.dart';
import 'package:elbekgram/draweritems/settings_page/editpage.dart';
import 'package:elbekgram/usermodel.dart';
import 'package:elbekgram/var_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class MySettings extends StatefulWidget {
  const MySettings({super.key});

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  late UserModel user;
  int currentIndex = 0;
  XFile? image;
  TextEditingController bioCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: StreamBuilder(
        stream: API.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          for (var i in snapshot.data!.docs) {
            if (i['uid'] == API.currentUser()?.uid) {
              user = UserModel.fromJson(i);
            }
          }
          return Scaffold(
              backgroundColor:
                  darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    elevation: 0,
                    pinned: true,
                    backgroundColor: darkMode
                        ? const Color(0xff47555E)
                        : const Color(0xff7AA5D2),
                    actions: [
                      PopupMenuButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        color: darkMode
                            ? const Color(0xff303841)
                            : const Color(0xffEEEEEE),
                        itemBuilder: (context) {
                          var list = <PopupMenuEntry<Object>>[
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Edit Name',
                                    style: TextStyle(
                                        color: darkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                chooseSource(context, darkMode);
                              },
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.person_outline_sharp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Set Profile Photo',
                                    style: TextStyle(
                                        color: darkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                API.singOut;
                              },
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      MaterialCommunityIcons.logout,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Log Out',
                                    style: TextStyle(
                                        color: darkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ];
                          list.insert(
                              1,
                              const PopupMenuDivider(
                                height: 5,
                              ));
                          return list;
                        },
                        child: Transform.rotate(
                          angle: 3.14 / 1,
                          child: SizedBox(
                            width: height * .047,
                            height: height * .047,
                            child: const Center(
                                child: Icon(
                              Icons.menu,
                              color: Colors.white,
                            )),
                          ),
                        ),
                      )
                    ],
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
                    expandedHeight: height * 0.17,
                    stretch: true,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.only(
                          left: width * 0.07, top: height * 0.07, bottom: 10),
                      title: Row(
                        children: [
                          OpenContainer(
                            closedColor: darkMode
                                ? const Color(0xff47555E)
                                : const Color(0xff7AA5D2),
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            closedElevation: 0,
                            closedBuilder: (context, action) => CircleAvatar(
                              radius: height * 0.026,
                              backgroundImage: NetworkImage(
                                  user.userImages[user.userImages.length - 1]),
                            ),
                            openBuilder: (context, action) {
                              return Scaffold(
                                body: StatefulBuilder(
                                    builder: (context, setState1) {
                                  return Container(
                                    decoration:
                                        const BoxDecoration(color: Colors.black),
                                    height: height,
                                    width: width,
                                    child: Scaffold(
                                      body: SafeArea(
                                        child: Column(
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 20,
                                                      left: 25,
                                                      right: 15),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: currentPlatform ==
                                                                TargetPlatform
                                                                    .android
                                                            ? const Icon(
                                                                Icons.arrow_back,
                                                                color:
                                                                    Colors.white,
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .arrow_back_ios,
                                                                color:
                                                                    Colors.white,
                                                              ),
                                                      ),
                                                      PopupMenuButton(
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                            10))),
                                                        color: const Color(
                                                            0xff303841),
                                                        itemBuilder: (context) {
                                                          var list =
                                                              <PopupMenuEntry<
                                                                  Object>>[
                                                            PopupMenuItem(
                                                              onTap: () async {
                                                                final urlImage = user
                                                                        .userImages[
                                                                    currentIndex];
                                                                final url =
                                                                    Uri.parse(
                                                                        urlImage);
                                                                final response =
                                                                    await http
                                                                        .get(url);
                                                                final bytes =
                                                                    response
                                                                        .bodyBytes;
                                                                final temp =
                                                                    await getTemporaryDirectory();
                                                                final path =
                                                                    "${temp.path}/image.jpg";
                                                                File(path)
                                                                    .writeAsBytesSync(
                                                                        bytes);
                                                                await Share
                                                                    .shareFiles([
                                                                  path
                                                                ], text: 'Profile photo of ${user.userFName} ${user.userLName} in Elbekgram');
                                                              },
                                                              child: const Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                15),
                                                                    child: Icon(
                                                                      MaterialCommunityIcons
                                                                          .share_variant_outline,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Share',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              onTap: () async {
                                                                final urlImage = user
                                                                    .userImages[user
                                                                        .userImages
                                                                        .length -
                                                                    1 -
                                                                    currentIndex];
                                                                try {
                                                                  final tempDir =
                                                                      await getTemporaryDirectory();
                                                                  final path =
                                                                      "${tempDir.path}/${user.uid}$currentIndex.jpg";
                                                                  await Dio()
                                                                      .download(
                                                                          urlImage,
                                                                          path);
                                                                  await GallerySaver
                                                                      .saveImage(
                                                                    path,
                                                                    albumName:
                                                                        'Elbekgram',
                                                                  );
                                                                } catch (e) {
                                                                  return;
                                                                }
                                                              },
                                                              child: const Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                15),
                                                                    child: Icon(
                                                                      MaterialCommunityIcons
                                                                          .progress_download,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Save to Gallery',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ];
                                                          list.insert(
                                                              1,
                                                              const PopupMenuDivider(
                                                                height: 5,
                                                              ));
                                                          return list;
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 20),
                                                          child: Transform.rotate(
                                                            angle: 3.14 / 1,
                                                            child: SizedBox(
                                                              width:
                                                                  height * .047,
                                                              height:
                                                                  height * .047,
                                                              child: const Center(
                                                                  child: Icon(
                                                                Icons.menu,
                                                                color:
                                                                    Colors.white,
                                                              )),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height * 0.04,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      (currentIndex + 1)
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 17),
                                                    ),
                                                    const Text(
                                                      ' of ',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 17),
                                                    ),
                                                    Text(
                                                      user.userImages.length
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 17),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: height * 0.12),
                                                      height: height * 0.4,
                                                      width: width,
                                                      child: PageView.builder(
                                                        onPageChanged: (value) {
                                                          setState1(
                                                            () {
                                                              currentIndex =
                                                                  value;
                                                            },
                                                          );
                                                        },
                                                        itemCount: user
                                                            .userImages.length,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Container(
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(user
                                                                      .userImages[user
                                                                          .userImages
                                                                          .length -
                                                                      1 -
                                                                      index]),
                                                                  fit: BoxFit
                                                                      .cover)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  width: width,
                                                  height: 200,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.red),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: height * 0.055,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: width * 0.4,
                                    child: Text(
                                      "${user.userFName} ${user.userLName}",
                                      style: const TextStyle(fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                SizedBox(
                                    width: width * 0.4,
                                    child: Text(
                                      user.userEmail,
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(),
                              Padding(
                                padding: EdgeInsets.only(left: width * 0.05),
                                child: const Text(
                                  'Account',
                                  style: TextStyle(
                                      color: Color(0xff7AA5D2),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              InkWell(
                                onLongPress: () async {
                                  if (user.userBio != '') {
                                    await Clipboard.setData(
                                        ClipboardData(text: user.userBio));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            duration:
                                                const Duration(seconds: 1),
                                            backgroundColor: darkMode
                                                ? const Color(0xff47555E)
                                                : const Color(0xff7AA5D2),
                                            content: const Row(
                                              children: [
                                                Icon(
                                                  Icons.copy,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  '  Bio copied to clipboard',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            )));
                                  }
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditPage(
                                              title: "Bio",
                                              user: user,
                                              info: user.userBio,
                                              controller: bioCon)));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: width * 0.05, top: 5, bottom: 5),
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        user.userBio == ''
                                            ? "None"
                                            : user.userBio,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      const Text(
                                        'Bio',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              InkWell(
                                onLongPress: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: user.userEmail));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: darkMode
                                              ? const Color(0xff47555E)
                                              : const Color(0xff7AA5D2),
                                          content: const Row(
                                            children: [
                                              Icon(
                                                Icons.copy,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                '  Email copied to clipboard',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          )));
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditPage(
                                              title: 'Email',
                                              user: user,
                                              info: user.userEmail,
                                              controller: emailCon)));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: width * 0.05, top: 5, bottom: 5),
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.userEmail,
                                        style: TextStyle(
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      const Text(
                                        'Email',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: darkMode ? Colors.black : Colors.grey,
                                thickness: 0.2,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }

  Future<dynamic> chooseSource(BuildContext context, bool darkMode) {
    return showDialog(
      barrierColor: null,
      context: context,
      builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor:
              darkMode ? const Color(0xff395781) : Colors.grey.shade50,
          shadowColor: Colors.black,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select source',
                style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      image = await ImagePicker().pickImage(
                          source: ImageSource.camera,
                          preferredCameraDevice: CameraDevice.front,
                          imageQuality: 50);
                      setState(() {});
                    },
                    child: const Text(
                      'Camera',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      image = await ImagePicker().pickImage(
                          source: ImageSource.gallery, imageQuality: 50);
                      setState(() {});
                    },
                    child: const Text(
                      'Gallery',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
