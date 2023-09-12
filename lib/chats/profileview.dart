import 'dart:io';
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
  UserModel userModel;

  MyProfile({super.key, required this.userModel});

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
              expandedHeight: height * 0.15,
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
                            widget.userModel.userImages[
                                widget.userModel.userImages.length - 1]),
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
                                                      final urlImage = widget
                                                              .userModel
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
                                                              'Profile photo of ${widget.userModel.userFName} ${widget.userModel.userLName} in Elbekgram');
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
                                                      final urlImage = widget
                                                          .userModel
                                                          .userImages[widget
                                                              .userModel
                                                              .userImages
                                                              .length -
                                                          1 -
                                                          currentIndex];
                                                      try {
                                                        final tempDir =
                                                            await getTemporaryDirectory();
                                                        final path =
                                                            "${tempDir.path}/${widget.userModel.uid}$currentIndex.jpg";
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
                                            widget.userModel.userImages.length
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
                                              itemCount: widget
                                                  .userModel.userImages.length,
                                              itemBuilder: (context, index) =>
                                                  Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(widget
                                                            .userModel
                                                            .userImages[widget
                                                                .userModel
                                                                .userImages
                                                                .length -
                                                            1 -
                                                            index]),
                                                        fit: BoxFit.cover)),
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
                      width: 5,
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
                                "${widget.userModel.userFName} ${widget.userModel.userLName}",
                                style: const TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              )),
                          SizedBox(
                              width: width * 0.4,
                              child: Text(
                                widget.userModel.userEmail,
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
                        if (widget.userModel.userBio != '')
                          InkWell(
                            onLongPress: () async {
                              if (widget.userModel.userBio != '') {
                                await Clipboard.setData(ClipboardData(
                                    text: widget.userModel.userBio));
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
                                    widget.userModel.userBio,
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
                                text: widget.userModel.userEmail));
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
                                left: width * 0.05, top: 5, bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(),
                                Text(
                                  widget.userModel.userEmail,
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
                          ),
                        ),
                        InkWell(
                          onLongPress: () async {
                            await Clipboard.setData(ClipboardData(
                                text:
                                    "${widget.userModel.country.characters.skip(5)}, ${widget.userModel.state}, ${widget.userModel.city}"));
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
                                  "${widget.userModel.country.characters.skip(5)}, ${widget.userModel.state}, ${widget.userModel.city}",
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
                        Divider(
                          color: darkMode ? Colors.black : Colors.grey,
                          thickness: 0.2,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: width * 0.07,
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
                                      Switch.adaptive(
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
