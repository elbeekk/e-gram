import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbekgram/chats/profileview.dart';
import 'package:elbekgram/messagemodel.dart';
import 'package:elbekgram/usermodel.dart';
import 'package:elbekgram/var_provider.dart';
import 'package:elbekgram/widgets/messagemodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String uid;
  UserModel userModel;

  ChatPage({super.key, required this.uid, required this.userModel});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String groupChatId = '';
  String currentUserId = '';
  String peerId = '';
  TextEditingController controller = TextEditingController();

  static String getConversationId(String id) =>
      FirebaseAuth.instance.currentUser!.uid.hashCode <= id.hashCode
          ? "${FirebaseAuth.instance.currentUser!.uid}_$id"
          : "${id}_${FirebaseAuth.instance.currentUser!.uid}";

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel user1) {
    return FirebaseFirestore.instance
        .collection('chats/${getConversationId(user1.uid)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(UserModel user, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
        toUid: user.uid,
        msg: msg,
        read: '',
        fromUid: FirebaseAuth.instance.currentUser!.uid,
        sent: time,
        type: Type.text);
    final ref = FirebaseFirestore.instance
        .collection('chats/${getConversationId(user.uid)}/messages/');
    await ref.doc().set(message.toJson());
  }

  @override
  void initState() {
    generateGroupId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentPlatform = Theme.of(context).platform;
    bool darkMode = Provider.of<VarProvider>(context).darkMode;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor:
                darkMode ? const Color(0xff47555E) : const Color(0xff7AA5D2),
            title: OpenContainer(
                clipBehavior: Clip.none,
                closedColor: darkMode
                    ? const Color(0xff47555E)
                    : const Color(0xff7AA5D2),
                closedElevation: 0,
                transitionDuration: const Duration(milliseconds: 500),
                transitionType: ContainerTransitionType.fade,
                closedBuilder: (context, action) => SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                height: width * .1,
                                width: width * .08,
                                child: currentPlatform == TargetPlatform.android
                                    ? Icon(
                                        Icons.arrow_back,
                                        color: darkMode
                                            ? Colors.white
                                            : Colors.white,
                                      )
                                    : Icon(
                                        Icons.arrow_back_ios,
                                        color: darkMode
                                            ? Colors.white
                                            : Colors.white,
                                      ),
                              )),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: height * .025,
                                backgroundImage: NetworkImage(widget
                                        .userModel.userImages[
                                    widget.userModel.userImages.length - 1]),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width * 0.45,
                                    child: Text(
                                      "${widget.userModel.userFName} ${widget.userModel.userLName}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  SizedBox(
                                    width: width * 0.45,
                                    child: Text(
                                      widget.userModel.userEmail,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.white),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {},
                                child: SizedBox(
                                    width: width * .1,
                                    height: width * 0.1,
                                    child: const Icon(
                                      Icons.call,
                                      color: Colors.white,
                                    )),
                              ),
                              PopupMenuButton(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                color: darkMode
                                    ? const Color(0xff303841)
                                    : const Color(0xffEEEEEE),
                                itemBuilder: (context) {
                                  var list = <PopupMenuEntry<Object>>[
                                    const PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 15),
                                            child: Icon(
                                              Ionicons.ios_volume_mute_outline,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            'Mute',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 15),
                                            child: Icon(
                                              Ionicons.videocam_outline,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text('Video Call'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 15),
                                            child: Icon(
                                              Ionicons.search_outline,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text('Search'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 15),
                                            child: Icon(
                                              MaterialCommunityIcons
                                                  .brush_variant,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text('Set Wallpaper'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () async {
                                         await FirebaseFirestore
                                            .instance
                                            .collection('chats')
                                            .doc(getConversationId(
                                                widget.userModel.uid))
                                            .collection('messages').get().then((value) {
                                              for( var i in value.docs){
                                                i.reference.delete();
                                              }
                                            },);
                                            
                                        print(
                                            '__________________DELETING____________________');
                                      },
                                      child: const Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 15),
                                            child: Icon(
                                              MaterialCommunityIcons.broom,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text('Clear History'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(
                                              MaterialCommunityIcons
                                                  .delete_outline,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text('Delete chat'),
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
                          )
                        ],
                      ),
                    ),
                openBuilder: (context, action) =>
                    MyProfile(userModel: widget.userModel))),
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        darkMode
                            ? 'assets/darkback.jpeg'
                            : 'assets/lightback.jpeg',
                      ),
                      fit: BoxFit.cover),
                ),
                child: StreamBuilder(
                  stream: getAllMessages(widget.userModel),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final message =
                              Message.fromJson(snapshot.data!.docs[index]);
                          final isMe = message.fromUid ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? true
                              : false;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 6),
                            child: Row(
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(15),
                                      topRight: const Radius.circular(15),
                                      bottomLeft: isMe
                                          ? const Radius.circular(15)
                                          : const Radius.circular(0),
                                      bottomRight: !isMe
                                          ? const Radius.circular(15)
                                          : const Radius.circular(0),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(message.msg),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                )),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: darkMode
                      ? const Color(0xff303841)
                      : const Color(0xffEEEEEE),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 17),
                      child: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                    Expanded(
                        flex: 13,
                        child: TextField(
                          controller: controller,
                          keyboardAppearance:
                              darkMode ? Brightness.dark : Brightness.light,
                          cursorHeight: height * .035,
                          cursorWidth: 1,
                          decoration: InputDecoration(
                              hintText: 'Message',
                              disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(.8),
                                  fontSize: 20),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        )),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          if (controller.text.isNotEmpty) {
                            sendMessage(widget.userModel, controller.text);
                            controller.text = '';
                          }
                        },
                        child: Container(
                          height: height * .08,
                          padding: const EdgeInsets.only(
                            right: 18,
                          ),
                          child: const Icon(
                            Icons.send,
                            size: 26,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void generateGroupId() {
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    peerId = widget.uid;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = "$currentUserId-$peerId";
    } else {
      groupChatId = "$peerId-$currentUserId";
    }
    updateDataFirestore('users', currentUserId, {'chattingWith': peerId});
  }

  sendChat({required String message}) async {
    MessageChat chat = MessageChat(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: Timestamp.now().toString(),
        content: message);
    await FirebaseFirestore.instance
        .collection('groupMessages')
        .doc(groupChatId)
        .collection('messages')
        .add(chat.tojson());
  }

  Future<void> updateDataFirestore(
    String collectionPath,
    String docPath,
    Map<String, dynamic> dataNeedUpdate,
  ) {
    return FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate);
  }
}
