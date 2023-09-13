import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbekgram/messagemodel.dart';
import 'package:elbekgram/pages/intro.dart';
import 'package:elbekgram/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../firebase_options.dart';

class API {
  static initialize() {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static String getConversationId(String id) =>
      FirebaseAuth.instance.currentUser!.uid.hashCode <= id.hashCode
          ? "${API.currentUser()?.uid}_$id"
          : "${id}_${API.currentUser()?.uid}";

  static singOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const IntroPage(),
        ),
            (route) => false);
  }

  static Future<void> sendMessage(UserModel user, String msg) async {
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    final Message message = Message(
        toUid: user.uid,
        msg: "$msg              ",
        read: '',
        fromUid: FirebaseAuth.instance.currentUser!.uid,
        sent: time,
        type: Type.text);
    final ref = FirebaseFirestore.instance
        .collection('chats/${API.getConversationId(user.uid)}/messages/')
        .doc(time.toString());
    await ref.set(message.toJson());
  }

  static Row myMessages(double width, bool darkMode, Message message,
      BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: width * 0.8,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      darkMode
                          ? const Color(0xff9400D3)
                          : const Color(0xffAFD5F0),
                      darkMode
                          ? const Color(0xff7C00B8)
                          : const Color(0xffAFD5F0),
                      darkMode
                          ? const Color(0xff64009D)
                          : const Color(0xff9DCAEB),
                      darkMode
                          ? const Color(0xff4B0081)
                          : const Color(0xff9DCAEB),
                    ]),
                color: darkMode
                    ? const Color(0xff47555E)
                    : const Color(0xff7AA5D2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(0),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(7, 7, 11, 7),
              child: Text(
                message.msg,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
                right: 3,
                bottom: 1,
                child: Row(
                  children: [
                    Text(
                      TimeOfDay.fromDateTime(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(message.sent),
                        ),
                      ).format(context),
                      style: TextStyle(
                          color: darkMode
                              ? Colors.white.withOpacity(.9)
                              : Colors.blue.shade900,
                          fontSize: 12),
                    ),
                    if (message.read.isEmpty)
                      Icon(
                        Icons.check,
                        size: 17,
                        color: darkMode
                            ? Colors.white.withOpacity(.9)
                            : Colors.blue.shade900,
                      ),
                    if (message.read.isNotEmpty)
                      Icon(
                        MaterialCommunityIcons.check_all,
                        size: 17,
                        color: darkMode
                            ? Colors.white.withOpacity(.9)
                            : Colors.blue.shade900,
                      )
                  ],
                ))
          ],
        ),
      ],
    );
  }

  static Row friendMessages(double width, bool darkMode, Message message,
      BuildContext context) {
    if (message.read.isEmpty) {
      FirebaseFirestore.instance
          .collection(
          'chats/${API.getConversationId(message.fromUid)}/messages/')
          .doc(message.sent)
          .update({'read': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString()});
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: width * 0.8,
              ),
              decoration: BoxDecoration(
                color: (darkMode
                    ? Colors.blueGrey.shade900
                    : Colors.grey.shade200),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(7, 7, 1, 7),
              child: Text(
                message.msg,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
                right: 7,
                bottom: 1,
                child: Text(
                  TimeOfDay.fromDateTime(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(message.sent),
                    ),
                  ).format(context),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ))
          ],
        ),
      ],
    );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  static Stream<User?> authStateChange() {
    return FirebaseAuth.instance.authStateChanges();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel user1) {
    return FirebaseFirestore.instance
        .collection('chats').doc(API.getConversationId(user1.uid)).collection('messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static passwordReset(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static signIn(String email, String password) {
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password);
  }

  static createUser(String email, String password) {
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  static verifyCurrentUser() {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  static deleteUser() {
    FirebaseFirestore.instance.collection('users').doc(
        FirebaseAuth.instance.currentUser!.uid).delete();
    FirebaseAuth.instance.currentUser!.delete();
  }

  static reload() {
    FirebaseAuth.instance.currentUser!.reload();
  }

  static bool verifiedResult() {
    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  static updateInDoc(String collection, String doc,
      Map<String, dynamic> item,) {
    FirebaseFirestore.instance.collection(collection).doc(doc).update(item);
  }

  static User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static getCurrentUserData() {
    FirebaseFirestore.instance.collection('users').doc(
        FirebaseAuth.instance.currentUser!.uid.toString());
  }

  static DocumentReference<Map<String, dynamic>> getMessageData(String uid, String docName) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(API.getConversationId(
        uid)).collection('messages').doc(docName);
    }
}
