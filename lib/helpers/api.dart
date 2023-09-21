import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:elbekgram/helpers/my_data_util.dart';
import 'package:elbekgram/helpers/widgets.dart';
import 'package:elbekgram/models/messagemodel.dart';
import 'package:elbekgram/pages/intro.dart';
import 'package:elbekgram/models/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'image_picker.dart';

class API {
  static late Timer timer;
  static Future<File?> uploadImage(ImageSource source,bool darkMode,BuildContext context)async{
    String? link;
    XFile? image;
    image = await ImagePickerService.pickCropImage(cropAspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), imageSource: source,darkMode: darkMode);
    final file = File(image!.path);
    final ref = FirebaseStorage.instance.ref().child('users/${API.currentUserAuth()?.email ?? ''}/${image.name}');
    var uploadTask = ref.putFile(file).whenComplete(() async { link = await ref.getDownloadURL();});
    await uploadTask.whenComplete(() async {
      try {
        if(link!.isNotEmpty){return await FirebaseFirestore.instance.collection('users').doc(API.currentUserAuth()!.uid).update(
            {'userImages':FieldValue.arrayUnion([link])}).whenComplete(()=> file);}
      } catch (onError) {
        if(link!.isNotEmpty){return await FirebaseFirestore.instance.collection('users').doc(API.currentUserAuth()!.uid).set(
            {'userImages':FieldValue.arrayUnion([link])}).whenComplete(()=> file);}
        print("Error (could not get URL)");
        link = 'https://t4.ftcdn.net/jpg/00/65/77/27/240_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg';
      }

    });
    return file;
  }
  static Future<String?> uploadImageInit(ImageSource source,bool darkMode,BuildContext context,)async{
    String? link;
    XFile? image;
    image = await ImagePickerService.pickCropImage(cropAspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), imageSource: source,darkMode: darkMode);
    final file = File(image!.path);
    final ref = FirebaseStorage.instance.ref().child('users/${API.currentUserAuth()?.email ?? ''}/${image.name}');
    var uploadTask = ref.putFile(file).whenComplete(() async { link = await ref.getDownloadURL();});
    await uploadTask.whenComplete(() async {
      try {
        if(link!.isNotEmpty){return await FirebaseFirestore.instance.collection('users').doc(API.currentUserAuth()!.uid).set(
            {'userImages':FieldValue.arrayUnion([link])}).whenComplete(()=> link);}else{
        await FirebaseFirestore.instance.collection('users').doc(API.currentUserAuth()!.email).update(
              {'userImages':FieldValue.arrayUnion(['https://t4.ftcdn.net/jpg/00/65/77/27/240_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg'])}).whenComplete(()=> file);
        }
      } catch (onError) {
        print("_________ Error in uploadImageInit _________");
      }

    });
    return link ?? 'https://t4.ftcdn.net/jpg/00/65/77/27/240_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg';
  }
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  static Future<void> sendPushNotification(UserModel user, String message) async {
    try {
      var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('user_info').doc('devices').get().then((value) async {
        for(var i in value['token']){
          final body = {
            "to": i.toString(),
            "notification": {
              "title": await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserAuth()!.uid)
                  .get()
                  .then((value) => "${value.data()?['userFirstName']} ${value.data()?['userLastName']}"),
              "body": message,
              'android_channel_id':"chats"
            },
            "data":{
              "from_uid":currentUserAuth()!.uid,
              "to_uid":user.uid,
            }
          };
          var response = await post(url,
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                "key=AAAAxETAcsQ:APA91bEPj1QbfCwRONwEkLDgZ9wNQ7W84dWSOi7-MmqXg1rIDeYZgu6cHumnp0WownKU64SmO6J9ORETOfZaoh6bGGOM_PopTSirPjvSWWi4ecf9xiFkRppNS7LE-JaW6odG2-LT6EvQ"
              },
              body: jsonEncode(body));
          print('RESPONSE STATUS ${response.statusCode}');
          print('RESPONSE BODY ${response.body}');
        }
      });
    } catch (e) {
      debugPrint("ERROR\n SEND NOTIFICATION ERROR${e.toString()}");
    }
  }
  static Future<void> updateActiveStatus(bool isOnline) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
        .update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }
  static Future<void> iosSignOut(BuildContext context,DeviceInfo) async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((value) async {
      if (value != null) {
        await FirebaseFirestore.instance.collection('users').doc(currentUserAuth()!.uid).collection('user_info').doc('devices')
            .update({"devices":
        FieldValue.arrayRemove([{"${readIosDeviceInfo(DeviceInfo)['name']}":readIosDeviceInfo(DeviceInfo),},],),
          'token':FieldValue.arrayRemove([value],),},).whenComplete(() =>  FirebaseAuth.instance.signOut()).whenComplete(() => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const IntroPage(),
            ),
                (route) => false));
      }
    });
  }
  static Future<void> androidSignOut(BuildContext context,var DeviceInfo) async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((value) async {
      if (value != null) {
        await FirebaseFirestore.instance.collection('users').doc(currentUserAuth()!.uid).collection('user_info').doc('devices')
            .update({"devices":FieldValue.arrayRemove([{"${readAndroidBuildData(DeviceInfo)['brand']} ${readAndroidBuildData(DeviceInfo)['model']}"
            :readAndroidBuildData(DeviceInfo)}]),'token':FieldValue.arrayRemove([value])}).whenComplete(() => FirebaseAuth.instance.signOut()).whenComplete(() => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const IntroPage(),
            ),
                (route) => false));
      }
    });


  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {return FirebaseFirestore.instance.collection('users').snapshots();
  }
  static User? currentUserAuth() {
    return FirebaseAuth.instance.currentUser;
  }
  static String getConversationId(String id) =>
      API.currentUserAuth()!.uid.hashCode <= id.hashCode
          ? "${API.currentUserAuth()!.uid}_$id"
          : "${id}_${API.currentUserAuth()!.uid}";
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel user1) {
    return FirebaseFirestore.instance
        .collection('chats/${getConversationId(user1.uid)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }
  static updateReadStatus(Message message) {
    FirebaseFirestore.instance
        .collection('chats/${API.getConversationId(message.fromUid)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }
  static sendMessage(String time, String uid) {
    return FirebaseFirestore.instance
        .collection('chats/${API.getConversationId(uid)}/messages/')
        .doc(time);
  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserSnapshot(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .snapshots();
  }
  static deleteAllMessages(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(API.currentUserAuth()!.uid).update({
      'chattingWith':FieldValue.arrayRemove([uid])});
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'chattingWith':FieldValue.arrayRemove([API.currentUserAuth()!.uid])});
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(API.getConversationId(uid))
        .collection('messages')
        .get()
        .then(
      (value) {
        for (var i in value.docs) {
          i.reference.delete();
        }
      },
    );
  }
  static deleteOneMessage(String uid,Message message,BuildContext context,bool darkMode)async{
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(API.getConversationId(uid))
        .collection('messages')
        .doc(message.sent)
        .delete()
        .whenComplete(() =>
        Widgets.snackBar(
            context,
            darkMode,
            Icons.delete_outline,
            'Successfully deleted',
            true));
  }
  static editMessage(String uid,String editMesTime,String editedMessage)async{
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(API.getConversationId(
        uid))
        .collection('messages')
        .doc(editMesTime)
        .update(
        {
          'msg':
          '$editedMessage               ',
        });
    }
    static addToChattingWith(String uid)async{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserAuth()!.uid)
          .update({'chattingWith': FieldValue.arrayUnion([uid,],),
          },
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'chattingWith': FieldValue.arrayUnion([currentUserAuth()!.uid],),
          },
      );
    }
    static void verifyCurrentEmail(BuildContext context,String uid,String email,bool isUpdate,String previousEmail,) async {
      timer = Timer.periodic(const Duration(seconds: 1), (timer1) async {
        await FirebaseAuth.instance.currentUser!.reload();
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
            await FirebaseFirestore.instance.collection('users').doc(
                uid).update({'userEmail': email});
            Navigator.pop(context);
            Navigator.pop(context);
          print('################ VERIFIED #################');
          timer1.cancel();
        }
      });
    }
  static Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build,) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
      ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }
  static Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
  static Future<void> updateAndroidInfo(AndroidDeviceInfo DeviceInfo) async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((value) async {
      if (value != null) {
        await FirebaseFirestore.instance.collection('users').doc(currentUserAuth()!.uid).collection('user_info').doc('devices')
            .update({"devices":FieldValue.arrayUnion([{"${readAndroidBuildData(DeviceInfo)['brand']} ${readAndroidBuildData(DeviceInfo)['model']}"
            :readAndroidBuildData(DeviceInfo)}]),'token':FieldValue.arrayUnion([value])});
      return value;
    }
    });

  }
  static deleteProfilePhoto(List images,int currentIndex) async {
    await FirebaseFirestore.instance.collection('users').doc(API.currentUserAuth()!.uid).update(
        {"userImages":FieldValue.arrayRemove([images[images.length -1-currentIndex]])});
  }
  static Future<void> updateIosInfo(IosDeviceInfo DeviceInfo) async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((value) async {
      if (value != null) {
        await FirebaseFirestore.instance.collection('users').doc(currentUserAuth()!.uid)
            .collection('user_info').doc('devices').update(  {"devices":FieldValue.arrayUnion([{"${readIosDeviceInfo(DeviceInfo)['name']}":readIosDeviceInfo(DeviceInfo)}]),
          'token':FieldValue.arrayUnion([value])});
        return value;
      }
    });
  }
  static Future<void> updateLocationInfo(Position data)async{
    DateTime time = DateTime.now();
    await FirebaseFirestore.instance.collection('users').doc(currentUserAuth()!.uid).collection('user_info').doc('location').
    collection("${time.day} ${MyDataUtil.getMonth(time)} ${time.year}").doc("${time.hour}:${time.minute}").set({'location':data.toJson()});
  }
  static Future<File?> pickMedia({required bool isGallery, required Future<File> Function(File? file) cropImage,}) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: source);
    if(pickedFile == null)return null;
    final file = File(pickedFile.path);
    return cropImage(file);
  }
}
