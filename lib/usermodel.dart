import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel {
  final String city;
  final String country;
  final String createdAt;
  final String docId;
  final String state;
  final String uid;
  final String userBio;
  final String userEmail;
  final List userImages;
  final String userName;

  UserModel({
    required this.city,
    required this.country,
    required this.createdAt,
    required this.docId,
    required this.state,
    required this.uid,
    required this.userBio,
    required this.userEmail,
    required this.userImages,
    required this.userName,
  });
  Map<String, dynamic> toJson(){
    return {
      "city": city,
      "country": country,
      "createdAt": createdAt,
      "docId": docId,
      "state": state,
      "uid": uid,
      "userBio": userBio,
      "userImages": userImages,
      "userName": userName,
    };
  }
  factory UserModel.fromJson(QueryDocumentSnapshot<Map<String,dynamic>> map){
    return UserModel(
        city: map['city'],
        country:  map['country'],
        createdAt: map['createdAt'],
        docId: map['docId'],
        state: map['state'],
        uid: map['uid'],
        userBio: map['userBio'],
        userEmail: map['userEmail'],
        userImages: map['userImages'],
        userName: map['userName']);
  }
}
