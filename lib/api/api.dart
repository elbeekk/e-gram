import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class API{
  static Future<void> updateActiveStatus(bool isOnline)async{
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid ?? '').update({'isOnline' : isOnline,'lastActive':DateTime.now().millisecondsSinceEpoch.toString()});
  }
}