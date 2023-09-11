import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String city;
  final String country;
  final String createdAt;
  final String state;
  final String uid;
  final String userBio;
  final String userEmail;
  final List userImages;
  final String userFName;
  final String userLName;

  UserModel({
    required this.city,
    required this.country,
    required this.createdAt,
    required this.state,
    required this.uid,
    required this.userBio,
    required this.userEmail,
    required this.userImages,
    required this.userFName,
    required this.userLName,
  });

  Map<String, dynamic> toJson() {
    return {
      "city": city,
      "country": country,
      "createdAt": createdAt,
      "state": state,
      "uid": uid,
      "userBio": userBio,
      "userEmail": userEmail,
      "userImages": userImages,
      "userFirstName": userFName,
      "userLastName": userLName,
    };
  }

  factory UserModel.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> map) {
    return UserModel(
        city: map['city'],
        country: map['country'],
        createdAt: map['createdAt'],
        state: map['state'],
        uid: map['uid'],
        userBio: map['userBio'],
        userEmail: map['userEmail'],
        userImages: map['userImages'],
        userFName: map['userFirstName'],
        userLName: map['userLastName']);
  }
}
