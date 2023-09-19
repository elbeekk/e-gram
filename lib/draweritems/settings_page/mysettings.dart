import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:elbekgram/draweritems/settings_page/editname.dart';
import 'package:elbekgram/helpers//api.dart';
import 'package:elbekgram/helpers/image_picker.dart';
import 'package:elbekgram/helpers/my_data_util.dart';
import 'package:elbekgram/helpers/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbekgram/draweritems/settings_page/editpage.dart';
import 'package:elbekgram/models/usermodel.dart';
import 'package:elbekgram/var_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_cropper/image_cropper.dart';
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
  PageController controller = PageController();  
  int currentIndex = 0;
  XFile? image;
  String link = '';
  TextEditingController bioCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  late var DeviceInfo;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Future<void> onclick(ImageSource source,bool darkMode)async{
    image = await ImagePickerService.pickCropImage(cropAspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), imageSource: source,darkMode: darkMode);
    final file = File(image!.path);
    final ref = FirebaseStorage.instance.ref().child('users/${API.currentUserAuth()?.uid ?? ''}/${image!.name}');
    var uploadTask = ref.putFile(file).whenComplete(() async { link = await ref.getDownloadURL();});
    await uploadTask.whenComplete(() async {
      try {
            if(link.isNotEmpty){return await FirebaseFirestore.instance.collection('users').doc(API.currentUserAuth()!.uid).update(
                {'userImages':FieldValue.arrayUnion([link])}).whenComplete((){ image=null;
            link='';});}
      } catch (onError) {
        Widgets.snackBar(context, darkMode, Icons.error_outline, "", true);
        print("Error (could not get URL)");
        setState(() {
          link = 'https://t4.ftcdn.net/jpg/00/65/77/27/240_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg';
        });
      }
    });
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          for (var i in snapshot.data!.docs) {
            if (i['uid'] == FirebaseAuth.instance.currentUser!.uid) {
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditName(
                                        fName: user.userFName,
                                        lName: user.userLName,
                                      ),
                                    ));
                              },
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
                              onTap: () async {
                                getDeviceInfo().whenComplete(() {
                                  if (TargetPlatform.iOS ==
                                      defaultTargetPlatform) {
                                    API.iosSignOut(context, DeviceInfo);
                                  } else {
                                    API.androidSignOut(context, DeviceInfo);
                                  }
                                });
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
                              return StatefulBuilder(
                                  builder: (context, setState1) {
                                return Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.black),
                                  height: height,
                                  width: width,
                                  child: SafeArea(
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, left: 25, right: 15),
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
                                                            color: Colors.white,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .arrow_back_ios,
                                                            color: Colors.white,
                                                          ),
                                                  ),
                                                  PopupMenuButton(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    color:
                                                        const Color(0xff303841),
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
                                                              ).whenComplete(
                                                                  () => print(
                                                                      '||||||||||||||| SAVED ||||||||||||||'));
                                                            } catch (e) {
                                                              print(
                                                                  "############### ${e.toString()} ###############");
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
                                                            if(user.userImages.length>1)PopupMenuItem(
                                                          onTap:() async {
                                                            if(user.userImages.length>1) {
                                                              await FirebaseFirestore.instance.collection('users').doc(API.currentUserAuth()!.uid).update(
                                                                {"userImages":FieldValue.arrayRemove([user.userImages[user.userImages.length -1-currentIndex]])}).whenComplete((){
                                                              });

                                                              }
                                                            },
                                                          child: const Row(
                                                            children: [
                                                              Padding(padding: EdgeInsets.only(right: 15),
                                                                child: Icon(
                                                                  MaterialCommunityIcons
                                                                      .delete_outline,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Delete Photo',
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
                                                          const EdgeInsets.only(
                                                              right: 20),
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
                                                  (currentIndex + 1).toString(),
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
                                                    controller: controller,
                                                    onPageChanged: (value) {
                                                      setState1(
                                                        () {
                                                          currentIndex = value;
                                                        },
                                                      );
                                                    },
                                                    itemCount:
                                                        user.userImages.length,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Container(
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(user.userImages[user.userImages.length -1 -index]),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Container(
                                            //   color: Colors.red,
                                            //   height: 100,
                                            //   width: width,
                                            //   child: ListView.builder(
                                            //       itemCount: widget.userModel.userImages.length,
                                            //       itemBuilder: ),
                                            // )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
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
                                      API.currentUserAuth()!.email ?? '',
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
                                  'Info',
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
                                                info: user.userBio,
                                                isBio: true,
                                              )));
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
                              InkWell(
                                onLongPress: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text:
                                          "${user.country.characters.skip(5)}, ${user.state}, ${user.city}"));
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
                                                '  Location copied to clipboard',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          )));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.05, top: 5, bottom: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(),
                                      Text(
                                        "${user.country.characters.skip(5)}, ${user.state}, ${user.city}",
                                        style: TextStyle(
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      const Text(
                                        'Location',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onLongPress: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text:
                                          API.currentUserAuth()!.email ?? ''));
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
                                                info: API
                                                        .currentUserAuth()!
                                                        .email ??
                                                    '',
                                                isBio: false,
                                              )));
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
                                        API.currentUserAuth()!.email ?? '',
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
                              InkWell(
                                onLongPress: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text:
                                          "${DateTime.fromMillisecondsSinceEpoch(int.parse(user.createdAt)).day} ${MyDataUtil.getMonth(DateTime.fromMillisecondsSinceEpoch(int.parse(user.createdAt)))} ${DateTime.fromMillisecondsSinceEpoch(int.parse(user.createdAt)).year}"));
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
                                                '  Joined Time copied to clipboard',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          )));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.05, top: 5, bottom: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(),
                                      Text(
                                        "${DateTime.fromMillisecondsSinceEpoch(int.parse(user.createdAt)).day} ${MyDataUtil.getMonth(DateTime.fromMillisecondsSinceEpoch(int.parse(user.createdAt)))} ${DateTime.fromMillisecondsSinceEpoch(int.parse(user.createdAt)).year}",
                                        style: TextStyle(
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      const Text(
                                        'Joined On',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
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
              darkMode ? const Color(0xff47555E) : const Color(0xff7AA5D2),
          shadowColor: Colors.black,
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select source',
                style: TextStyle(
                    color: Colors.white,
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
                      onclick(ImageSource.camera,darkMode);
                    },
                    child: const Text(
                      'Camera',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      onclick(ImageSource.gallery,darkMode);
                    },
                    child: const Text(
                      'Gallery',
                      style: TextStyle(
                          color: Colors.white,
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

  Future<void> getDeviceInfo() async {
    if (TargetPlatform.iOS == defaultTargetPlatform) {
      DeviceInfo = await deviceInfo.iosInfo;
    } else {
      DeviceInfo = await deviceInfo.androidInfo;
    }
  }
}
