import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbekgram/api/my_data_util.dart';
import 'package:elbekgram/usermodel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:animations/animations.dart';
import 'package:dio/dio.dart';
import 'package:elbekgram/var_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class MyProfile extends StatefulWidget {
  String uid;

  MyProfile({super.key, required this.uid});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool isMuted = true;
  bool isStreched = false;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').where('uid',isEqualTo: widget.uid).limit(1).snapshots(),
      builder: (context, snapshot) {
        UserModel user = UserModel.fromJson(snapshot.data!.docs[0]);
        return Scaffold(
            backgroundColor:
            darkMode ? const Color(0xff303841) : const Color(0xffEEEEEE),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  pinned: true,
                  backgroundColor:
                  darkMode ? const Color(0xff47555E) : const Color(0xff7AA5D2),
                  actions: [
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {},
                      child: SizedBox(
                        width: width * 0.13,
                        child: const Icon(Ionicons.videocam),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {},
                      child: SizedBox(
                        width: width * 0.13,
                        child: const Icon(Icons.call),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        DynamicLinkProvider().generateShareLink(user);
                      },
                      child: Transform.rotate(
                        angle: 3.14 / 1.3,
                        child: SizedBox(
                            width: width * .13,
                            child: Icon(
                              Ionicons.link_outline,
                            )),
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
                          transitionDuration: const Duration(milliseconds: 500),
                          closedElevation: 0,
                          closedBuilder: (context, action) => CircleAvatar(
                            radius: height * 0.026,
                            backgroundImage: NetworkImage(
                               user.userImages[
                                user.userImages.length - 1]),
                          ),
                          openBuilder: (context, action) {
                            return StatefulBuilder(builder: (context, setState1) {
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
                                              top: 20,
                                              left: 25,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: currentPlatform ==
                                                      TargetPlatform.android
                                                      ? const Icon(
                                                    Icons.arrow_back,
                                                    color: Colors.white,
                                                  )
                                                      : const Icon(
                                                    Icons.arrow_back_ios,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                PopupMenuButton(
                                                  icon: const Icon(
                                                    Ionicons.ellipsis_vertical,
                                                    color: Colors.white,
                                                  ),
                                                  surfaceTintColor: Colors.white,
                                                  shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10))),
                                                  color: const Color(0xff303841),
                                                  itemBuilder: (context) {
                                                    var list =
                                                    <PopupMenuEntry<Object>>[
                                                      PopupMenuItem(
                                                        onTap: () async {
                                                          final urlImage = user
                                                              .userImages[
                                                          currentIndex];
                                                          final url =
                                                          Uri.parse(urlImage);
                                                          final response =
                                                          await http.get(url);
                                                          final bytes =
                                                              response.bodyBytes;
                                                          final temp =
                                                          await getTemporaryDirectory();
                                                          final path =
                                                              "${temp.path}/image.jpg";
                                                          File(path)
                                                              .writeAsBytesSync(
                                                              bytes);
                                                          await Share.shareFiles(
                                                              [path],
                                                              text:
                                                              'Profile photo of ${user.userFName} ${user.userLName} in Elbekgram');
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                              EdgeInsets.only(
                                                                  right: 15),
                                                              child: Icon(
                                                                MaterialCommunityIcons
                                                                    .share_variant_outline,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Share',
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        onTap: () async {
                                                          final urlImage = user.userImages[user.userImages
                                                              .length -
                                                              1 -
                                                              currentIndex];
                                                          try {
                                                            final tempDir =
                                                            await getTemporaryDirectory();
                                                            final path =
                                                                "${tempDir.path}/${user.uid}$currentIndex.jpg";
                                                            await Dio().download(
                                                                urlImage, path);
                                                            await GallerySaver
                                                                .saveImage(
                                                              path,
                                                              albumName:
                                                              'Elbekgram',
                                                            );
                                                          } catch (e) {
                                                            print('Error1');
                                                          }
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                              EdgeInsets.only(
                                                                  right: 15),
                                                              child: Icon(
                                                                MaterialCommunityIcons
                                                                    .progress_download,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Save to Gallery',
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.white),
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
                                                ),
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
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17),
                                              ),
                                              const Text(
                                                ' of ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17),
                                              ),
                                              Text(
                                                user.userImages.length
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
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
                                                  pageSnapping: true,
                                                  onPageChanged: (value) {
                                                    setState1(
                                                          () {
                                                        currentIndex = value;
                                                      },
                                                    );
                                                  },
                                                  itemCount: user.userImages.length,
                                                  itemBuilder: (context, index) =>
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(user.userImages[user.userImages
                                                                    .length -
                                                                    1 -
                                                                    index]),
                                                                fit: BoxFit.cover)),
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),

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
                          width: 8,
                        ),
                        SizedBox(
                          height: height * 0.05,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: width * 0.4,
                                  child: Text(
                                    "${user.userFName} ${user.userLName}",
                                    style: const TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              SizedBox(
                                  width: width * 0.4,
                                  child: Text(
                                    user.isOnline ? 'Online': MyDataUtil().getLastActive(context: context, lastActive: user.lastActive),
                                    style: const TextStyle(fontSize: 10,fontWeight: FontWeight.normal),
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
                        padding: EdgeInsets.only(top: 15),
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
                            if (user.userBio != '')
                              InkWell(
                                onLongPress: () async {
                                  if (user.userBio != '') {
                                    await Clipboard.setData(ClipboardData(
                                        text: user.userBio));
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
                                                  '  Bio copied to clipboard',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            )));
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.05, bottom: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        user.userBio,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Bio',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            InkWell(
                              onLongPress: () async {
                                await Clipboard.setData(ClipboardData(
                                    text: user.userEmail));
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: width * 0.05,
                                    top: 5,
                                    bottom: 5,
                                    right: width * 0.05),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Row(),
                                        Text(
                                          user.userEmail,
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
                                          'Email',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
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
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: width * 0.05, top: 5, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    "${DateTime.fromMillisecondsSinceEpoch(int.parse(user.createdAt)).day} ${MyDataUtil.getMonth(DateTime.fromMillisecondsSinceEpoch(int.parse(user.createdAt)))} ${DateTime.fromMillisecondsSinceEpoch(int.parse(user.createdAt)).year}"));
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: width * 0.05, top: 5, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            Divider(
                              color: darkMode ? Colors.black : Colors.grey,
                              thickness: 0.2,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: width * 0.05,
                                    top: 5,
                                    bottom: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notifications',
                                          style: TextStyle(
                                              color: darkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          isMuted ? 'Off' : 'On',
                                          style:
                                          const TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    VerticalDivider(
                                      color: darkMode ? Colors.black : Colors.grey,
                                      thickness: 10,
                                      indent: 0,
                                      width: 10,
                                      endIndent: 0,
                                    ),
                                    SizedBox(
                                      height: height * 0.05,
                                      child: Row(
                                        children: [
                                          VerticalDivider(
                                            color: darkMode
                                                ? Colors.black
                                                : Colors.grey,
                                            thickness: .2,
                                            indent: 5,
                                            width: 2,
                                            endIndent: 5,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isMuted = !isMuted;
                                              });

                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(height*0.02),
                                              child: Switch.adaptive(
                                                activeColor: darkMode
                                                    ? const Color(0xff47555E)
                                                    : const Color(0xff7AA5D2),
                                                value: !isMuted,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isMuted = !isMuted;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
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
    );
  }

  Future<File?> downloadFile(userImag, String fileName) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File("${appStorage.path}/$fileName");
    final response = await Dio().get(
      userImag,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  }
}
